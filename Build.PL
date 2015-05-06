use Module::Build;

my $build = Module::Build->new
(
    module_name    => 'FiveDice',
    dist_version   => '0.0.1',
    dist_author   => 'Jeff Smigel',
    requires       => {
    },
    dist_abstract => "five-dice",
    recursive_test_files => 1,
);

$build->create_build_script;
