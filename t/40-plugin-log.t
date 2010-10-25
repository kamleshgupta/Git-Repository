    if !Git::Repository::Command::_is_git('git');
        body    => "of data\n",
    my ( $id, $log, %more ) = @_;
    my $commit = { %{ $commit{$id} }, %more };
# various options combinations
my @options;

BEGIN {
    @options = (
        [ [qw( -p -- file )], [ <<'DIFF', << 'DIFF'] ],
diff --git a/file b/file
index e69de29..dcf168c 100644
--- a/file
+++ b/file
@@ -0,0 +1 @@
+line 1
\ No newline at end of file
DIFF
diff --git a/file b/file
new file mode 100644
index 0000000..e69de29
DIFF
        [ [qw( file )],            [ '', '' ] ],
        [ [qw( --decorate file )], [ '', '' ], '1.5.2.rc0' ],
        [ [qw( --pretty=raw )],    [ '', '' ] ],
    );
    $tests += 13 * @options;
}

for my $o (@options) {
    my ( $args, $extra, $minver ) = @$o;
    @log = $r->log(@$args);
SKIP: {
        skip "git log @$args needs $minver, we only have $version", 13
            if $minver && Git::Repository->version_lt($minver);
        is( scalar @log, 2, "2 commits for @$args" );
        isa_ok( $_, 'Git::Repository::Log' ) for @log;
        check_commit( 2 => $log[0], extra => $extra->[0] );
        check_commit( 1 => $log[1], extra => $extra->[1] );
    }
}

my @badopts;

BEGIN {
    @badopts = ( [qw( --pretty=oneline )], [qw( --graph )], );
    $tests += 2 * @badopts;
}
for my $badopt (@badopts) {
    ok( !eval { $r->log(@$badopt) }, "bad options: @$badopt" );
    like( $@, qr/^log\(\) cannot parse @$badopt/, '.. expected error' );
}
