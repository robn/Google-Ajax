use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Google::Ajax',
    AUTHOR              => q{Robert Norris <rob@cataclysm.cx>},
    VERSION_FROM        => 'lib/Google/Ajax.pm',
    ABSTRACT_FROM       => 'lib/Google/Ajax.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Google-Ajax-*' },
);
