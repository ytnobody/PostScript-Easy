use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'PostScript::Easy',
    'VERSION_FROM'	=> 'lib/PostScript/Easy.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.008001 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/PostScript/Easy.pm', # retrieve abstract from module
       AUTHOR     => 'Satoshi Azuma <ytnobody@gmail.org>') : ()),
);
