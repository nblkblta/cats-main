package CATS::UI::Judges;

use strict;
use warnings;

use CATS::DB;
use CATS::DevEnv;
use CATS::Form;
use CATS::Globals qw($is_jury $is_root $t);
use CATS::IP;
use CATS::Job;
use CATS::Judge;
use CATS::JudgeDB;
use CATS::ListView;
use CATS::Messages qw(msg res_str);
use CATS::Output qw(init_template url_f);
use CATS::References;

sub _submenu { $t->param(submenu => [ CATS::References::menu('judges') ]); }

our $form = CATS::Form->new(
    table => 'judges J',
    fields => [
        [ name => 'name', db_name => 'nick', validators => [ CATS::Field::str_length(1, 20) ], caption => 625 ],
        [ name => 'pin_mode', validators => [ CATS::Field::int_range(min => 0, max => 10) ], caption => 678 ],
        [ name => 'account_id', ],
    ],
    joins => [ { sql => 'LEFT JOIN accounts A ON A.id = J.account_id', fields => 'A.login AS account_name' } ],
    href_action => 'judges_edit',
    descr_field => 'nick',
    template_var => 'j',
    msg_saved => 1140,
    msg_deleted => 1020,
    before_save_db => sub {
        my ($data, $id) = @_;
        $id and return;
        $data->{is_alive} = 0;
        $data->{alive_date} = \'CURRENT_TIMESTAMP';
    },
    before_display => sub {
        my ($fd, $p) = @_;
        $fd->{de_bitmap} = $fd->{id} &&
            CATS::DB::select_row('judge_de_bitmap_cache', '*', { judge_id => $fd->{id} });
        if ($fd->{de_bitmap}) {
            my $dev_env = CATS::DevEnv->new(CATS::JudgeDB::get_DEs);
            $fd->{supported_DEs} = [
                $dev_env->by_bitmap([ CATS::JudgeDB::extract_de_bitmap($fd->{de_bitmap}) ]) ],
        }
        if (my $aid = $fd->{indexed}->{account_id}->{value}) {
            $fd->{href_contests} = url_f('contests', search => "has_user($aid)");
        }
        $fd->{extra_fields}->{account_name} = $p->{account_name} if $p->{account_name};
        _submenu;
    },
    validators => [ sub {
        my ($fd, $p) = @_;
        $fd->{indexed}->{account_id}->{value} = undef;
        $p->{account_name} or return 1;
        $fd->{indexed}->{account_id}->{value} = $dbh->selectrow_array(q~
            SELECT id FROM accounts WHERE login = ?~, undef,
            $p->{account_name}) and return 1;
        $fd->{account}->{error} = res_str(1139, $p->{account_name});
        undef;
    } ],
);

sub judges_edit_frame {
    my ($p) = @_;
    init_template($p, 'judges_edit.html.tt');
    $is_root or return;
    $form->edit_frame($p, redirect => [ 'judges' ]);
}

sub update_judges {
    my ($p) = @_;

    my $count = 0;
    for my $judge_id (@{$p->{selected}}) {
        CATS::Job::create($cats::job_type_update_self, { judge_id => $judge_id }) and ++$count;
    }
    $count or return;
    $dbh->commit;
    msg(1171, $count);
}

sub set_pin_mode {
    my ($p) = @_;

    my $count = 0;
    my $sth = $dbh->prepare(q~
        UPDATE judges SET pin_mode = ? WHERE pin_mode <> ? AND id = ?~);
    $count += $sth->execute($p->{pin_mode}, $p->{pin_mode}, $_) for @{$p->{selected}};
    $count or return;
    $dbh->commit;
    msg(1172, $count);
}

sub judges_frame {
    my ($p) = @_;
    $is_jury or return;

    if ($is_root) {
        if ($p->{ping}) {
            CATS::Judge::ping($p->{ping});
            return $p->redirect(url_f 'judges');
        }
        $p->{update} and update_judges($p);
        $p->{set_pin_mode} && defined $p->{pin_mode} and set_pin_mode($p);
    }

    init_template($p, 'judges.html.tt');
    my $lv = CATS::ListView->new(web => $p, name => 'judges');

    $is_root and $form->delete_or_saved($p);

    $lv->define_columns(url_f('judges'), 0, 0, [
        { caption => res_str(625), order_by => 'nick', width => '15%' },
        ($is_root ? ({ caption => res_str(616), order_by =>  'login', width => '25%', col => 'Lg' }) : ()),
        ($is_root ? ({ caption => res_str(649), order_by => 'processing_count', width => '10%', col => 'Rq' }) : ()),
        { caption => res_str(626), order_by => 'is_alive', width => '10%', col => 'Re' },
        { caption => res_str(633), order_by => 'alive_date', width => '10%', col => 'Ad' },
        { caption => res_str(622), order_by => 'pin_mode', width => '10%' },
        { caption => res_str(676), order_by => 'version', width => '15%', col => 'Vr' },
    ]);
    $lv->define_db_searches([ qw(J.id nick login version is_alive alive_date pin_mode account_id last_ip) ]);

    my $req_counts =
        !$is_root || !$lv->visible_cols->{Rq} ? ', NULL AS processing_count, NULL AS processed_count' :
        qq~,
        (SELECT COUNT(*) FROM reqs R WHERE R.judge_id = J.id AND R.state <= $cats::st_testing) AS processing_count,
        (SELECT COUNT(*) FROM reqs R WHERE R.judge_id = J.id) AS processed_count~;

    my $c = $dbh->prepare(qq~
        SELECT
            J.id AS jid, J.nick AS judge_name, A.login AS account_name,
            J.version, J.is_alive, J.alive_date, J.pin_mode,
            A.id AS account_id, A.last_ip, A.restrict_ips$req_counts
        FROM judges J LEFT JOIN accounts A ON A.id = J.account_id WHERE 1 = 1 ~ .
        $lv->maybe_where_cond . $lv->order_by);
    $c->execute($lv->where_params);

    my $fetch_record = sub {
        my $row = $_[0]->fetchrow_hashref or return ();
        my $jid = $row->{jid};
        return (
            %$row,
            CATS::IP::linkify_ip($row->{last_ip}),

            href_ping => url_f('judges', ping => $jid),
            href_edit => url_f('judges_edit', id => $jid),
            href_delete => url_f('judges', 'delete' => $jid),
            href_account => url_f('users_edit', uid => $row->{account_id}),
            href_console => url_f('console',
                search => "judge_id=$jid,state<=T", se => 'judge', i_value => -1, show_results => 1),
            href_update_jobs => url_f('jobs',
                search => "judge_id=$jid,type=$cats::job_type_update_self"),
        );
    };

    $lv->attach(url_f('judges'), $fetch_record, $c);

    _submenu;
    $t->param(editable => $is_root);

    my ($not_processed) = $dbh->selectrow_array(q~
        SELECT COUNT(*) FROM reqs WHERE state = ? AND judge_id IS NULL~, undef,
        $cats::st_not_processed);
    $t->param(not_processed => $not_processed);
}

1;
