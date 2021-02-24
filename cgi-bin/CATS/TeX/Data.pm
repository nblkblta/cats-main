package CATS::TeX::Data;

# TeX command without backslash => html/mathml entity without '&' and ';'.
# Alphabetic order.
our %binary = (
    amalg => '#2A3F',
    approx => 'asymp',
    ast => '#x2A',
    asymp => '#224D',
    bigcirc => '#x25CB',
    bigtriangledown => '#x25BD'.
    bigtriangleup => '#x25B3'.
    bowtie => '#x22C8',
    bullet => 'bull',
    cap => 'cap',
    cdot => '#x22C5',
    cdots => '#x22ef',
    circ => '#x2218',
    cong => '#x2245',
    cup => 'cup',
    dagger => '#x2020',
    dashv => '#x22A3',
    ddagger => '#x2021',
    diamond => '#x25C6',
    div => 'divide',
    doteq => '#x2250',
    equiv => 'equiv',
    frown => '#x2322',
    ge => 'ge',
    geq => 'ge',
    geqslant => '#x2A7E',
    gg => '#x226B',
    gt => 'gt',
    in => 'isin',
    Join => '#x2A1D',
    land => 'and',
    le => 'le',
    leq => 'le',
    leqslant => '#x2A7D',
    lhd => '#x22B2',
    ll => '#x226A',
    lnot => 'not',
    lor => 'or',
    lt => 'lt',
    mid => '#x2223',
    models => '#x22A8',
    mp => '#x2213',
    ne => 'ne',
    neq => 'ne',
    ni => 'ni',
    notin => 'notin',
    odot => '#x2299',
    ominus => '#x2296',
    oplus => 'oplus',
    oslash => 'empty',
    otimes => 'otimes',
    parallel =>'#x2225',
    perp => 'perp',
    pm => '#xB1',
    prec => '#x227A',
    preceq => '#x2AAF',
    propto => '#x221D',
    rhd => '#x22B3',
    setminus => '#x2216',
    sim => 'sim',
    simeq => '#x2243',
    smile => '#x2323',
    sqcap => '#x2293',
    sqcup => '#x2294',
    star => '#x22C6',
    sqsubset => '#x228F',
    sqsubseteq => '#x2291',
    sqsupset => '#x2290',
    sqsupseteq => '#x2292',
    subset => 'sub',
    subseteq => 'sube',
    succ => '#x227B',
    succeq => '#x2AB0',
    supset => 'sup',
    supseteq => 'supe',
    times => 'times',
    triangleleft => '#x25C3',
    triangleright => '#x25B9',
    to => '#x21A6',
    unlhd => '#x22B4',
    unrhd => '#x22B5',
    uplus => '#x2A04',
    vdash => '#x22A2',
    vee => 'and',
    wedge => 'or',
    wr => '#x2240',
);

my %arrows = (
    Rightarrow => 'rArr',
    Leftarrow => 'lArr',
    Leftrightarrow => 'hArr',
    Uparrow => 'uArr',
    Downarrow => 'dArr',
    leftarrow => 'larr',
    rightarrow => 'rarr',
    uparrow => 'uarr',
    downarrow => 'darr',
    mapsto => '#8614',
);

our %large = (
    bigcap => '#x22C2',
    bigcup => '#x22C3',
    bigodot => '#x2A00',
    bigoplus => '#x2A01',
    bigotimes => '#x2A02',
    bigsqcap => '#x2A05',
    bigsqcup => '#x2A06',
    biguplus => '#x2A04',
    bigvee => '#x22C1',
    bigwedge => '#x22C0',
    coprod => 'coprod',
    int => 'int',
    oint => '#x222E',
    sum => 'sum',
    prod => 'prod',
);

my %special = (
    deg => 'deg',
    'sqrt' => '#x221A',
    partial => 'part',
    triangle => '#x25B3',
    angle => 'ang',
    infty => 'infin',
    forall => 'forall',
    'exists' => 'exist',
    emptyset => 'empty',
    neg => '#xAC',
    nabla => 'nabla',
    dots => 'hellip',
    ldots => 'hellip',
    goodbreak => 'zwnj',
    leftguilsingl => 'lsaquo',
    nobreak => 'zwj',
    quotedblbase => 'bdquo',
    quotesinglbase => 'sbquo',
    rightguilsingl => 'rsaquo',
    lceil => '#x2308',
    rceil => '#x2309',
    lfloor => '#x230A',
    rfloor => '#x230B',
    langle => '#x2329',
    rangle => '#x232A',
    lvert => '#124',
    rvert => '#124',
    lVert => '#8741',
    rVert => '#8741',
);

# Rough approximation.
my %spaces = (
    ';' => 'nbsp',
    ':' => 'nbsp',
    ',' => '#x202F',
    quad => '#x2001',
    qquad => '#x2001;&#x2001',
);

my %greek = (
    Alpha => 'Alpha',
    Beta => 'Beta',
    Chi => 'Chi',
    Delta => 'Delta',
    Epsilon => 'Epsilon',
    Eta => 'Eta',
    Gamma => 'Gamma',
    Iota => 'Iota',
    Kappa => 'Kappa',
    Lambda => 'Lambda',
    Mu => 'Mu',
    Nu => 'Nu',
    Omega => 'Omega',
    Omicron => 'Omicron',
    Phi => 'Phi',
    Pi => 'Pi',
    Psi => 'Psi',
    Rho => 'Rho',
    Sigma => 'Sigma',
    Tau => 'Tau',
    Theta => 'Theta',
    Upsilon => 'Upsilon',
    Xi => 'Xi',
    Zeta => 'Zeta',
    alpha => 'alpha',
    beta => 'beta',
    chi => 'chi',
    delta => 'delta',
    epsilon => 'epsilon',
    eta => 'eta',
    gamma => 'gamma',
    iota => 'iota',
    kappa => 'kappa',
    lambda => 'lambda',
    mu => 'mu',
    nu => 'nu',
    omega => 'omega',
    omicron => 'omicron',
    phi => 'phi',
    pi => 'pi',
    psi => 'psi',
    rho => 'rho',
    sigma => 'sigma',
    tau => 'tau',
    theta => 'theta',
    upsilon => 'upsilon',
    varsigma => 'sigmaf',
    xi => 'xi',
    zeta => 'zeta',
);

my %old = (
    alef => '#x5D0',
    ayin => '#x5E2',
    bet => '#x5D1',
    dalet => '#x5D3',
    finalkaf => '#x5DA',
    finalmem => '#x5DD',
    finalnun => '#x5DF',
    finalpe => '#x5E3',
    finaltsadi => '#x5E5',
    gimel => '#x5D2',
    he => '#x5D4',
    het => '#x5D7',
    kaf => '#x5DB',
    lamed => '#x5DC',
    mem => '#x5DE',
    nun => '#x5E0',
    pe => '#x5E4',
    qof => '#x5E7',
    resh => '#x5E8',
    samekh => '#x5E1',
    shin => '#x5E9',
    tav => '#x5EA',
    tet => '#x5D8',
    tsadi => '#x5E6',
    vav => '#x5D5',
    yod => '#x5D9',
    zayin => '#x5D6',
);

# Combining, large.
our %accents = (
    acute => [  769, '\'' ],
    bar   => [  773, '&#175;' ],
    breve => [  774, '&#728;' ],
    check => [  780, 'v' ],
    dot   => [  775, '&#183;' ],
    ddot  => [  776, '&#183;' ],
    grave => [  768, '`' ],
    hat   => [  770, '^' ],
    tilde => [  771, '~' ],
    vec   => [ 8407, '&#8594;' ],
);

our %symbols = (%binary, %arrows, %special, %spaces, %greek, %old);
$_ = "\&$_;" for values %symbols, values %large;
$symbols{' '} = '&nbsp;';
$symbols{'-'} = '&minus;',
$symbols{rbrace} = $symbols{'}'} = '}';
$symbols{lbrace} = $symbols{'{'} = '{';
$symbols{backslash} = '\\';

1;
