package CATS::Judges;

use strict;
use warnings;

use CATS::Web qw(param url_param);
use CATS::DB;
use CATS::Misc qw(
    $t $is_jury $is_root
    init_template init_listview_template msg res_str url_f
    order_by define_columns attach_listview references_menu);
use CATS::Utils qw(param_on);


sub judges_new_frame
{
    init_template('judges_new.html.tt');
    $t->param(href_action => url_f('judges'));
}


sub judges_new_save
{
    my $judge_name = param('judge_name');
    my $locked = param_on('locked');

    $judge_name ne '' && length $judge_name <= 20
        or return msg(005);

    $dbh->do(qq~
        INSERT INTO judges (
            id, nick, accept_contests, accept_trainings, lock_counter, is_alive, alive_date
        ) VALUES (?, ?, 1, 1, ?, 0, CURRENT_TIMESTAMP)~, {},
        new_id, $judge_name, $locked ? -1 : 0);
    $dbh->commit;
}


sub judges_edit_frame
{
    init_template('judges_edit.html.tt');

    my $jid = url_param('edit');
    my ($judge_name, $lock_counter) = $dbh->selectrow_array(qq~
        SELECT nick, lock_counter FROM judges WHERE id=?~, {}, $jid);
    $t->param(id => $jid, judge_name => $judge_name, locked => $lock_counter, href_action => url_f('judges'));
}


sub judges_edit_save
{
    my $jid = param('id');
    my $judge_name = param('judge_name') || '';
    my $locked = param_on('locked');

    $judge_name ne '' && length $judge_name <= 20
        or return msg(005);

    $dbh->do(qq~
        UPDATE judges SET nick = ?, lock_counter = ? WHERE id = ?~, {},
        $judge_name, $locked ? -1 : 0, $jid);
    $dbh->commit;
}


sub judges_frame
{
    $is_jury or return;

    if (defined url_param('delete')) {
        my $jid = url_param('delete');
        $dbh->do(qq~DELETE FROM judges WHERE id=?~, {}, $jid);
        $dbh->commit;
    }

    $is_root && defined url_param('new') and return judges_new_frame;
    $is_root && defined url_param('edit') and return judges_edit_frame;

    init_listview_template('judges', 'judges', 'judges.html.tt');

    $is_root && defined param('new_save') and judges_new_save;
    $is_root && defined param('edit_save') and judges_edit_save;

    define_columns(url_f('judges'), 0, 0, [
        { caption => res_str(625), order_by => '2', width => '65%' },
        { caption => res_str(626), order_by => '3', width => '10%' },
        { caption => res_str(633), order_by => '4', width => '15%' },
        { caption => res_str(622), order_by => '5', width => '10%' }
    ]);

    my $c = $dbh->prepare(qq~
        SELECT id, nick, is_alive, alive_date, lock_counter
            FROM judges ~ . order_by);
    $c->execute;

    my $fetch_record = sub($)
    {
        my ($jid, $judge_name, $is_alive, $alive_date, $lock_counter) = $_[0]->fetchrow_array
            or return ();
        return (
            editable => $is_root,
            jid => $jid, judge_name => $judge_name,
            locked => $lock_counter,
            is_alive => $is_alive,
            alive_date => $alive_date,
            href_edit=> url_f('judges', edit => $jid),
            href_delete => url_f('judges', 'delete' => $jid)
        );
    };

    attach_listview(url_f('judges'), $fetch_record, $c);

    $t->param(submenu => [ references_menu('judges') ], editable => 1);

    my ($not_processed) = $dbh->selectrow_array(q~
        SELECT COUNT(*) FROM reqs WHERE state = ?~, undef,
        $cats::st_not_processed);
    $t->param(not_processed => $not_processed);

    $dbh->do(qq~
        UPDATE judges SET is_alive = 0, alive_date = CURRENT_TIMESTAMP WHERE is_alive = 1~);
    $dbh->commit;
}


1;
