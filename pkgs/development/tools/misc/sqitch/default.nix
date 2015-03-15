{ stdenv, writeScript, makeWrapper, sqitchModule }:
stdenv.mkDerivation rec {
  name = "sqitch-0.999";
  buildInputs = [ makeWrapper ];
  propagatedNativeBuildInputs = [ sqitchModule ];
  builder = writeScript (name + "-builder.sh") ''
    . ${stdenv}/setup
    mkdir -p $out/bin
    cp ${sqitchModule}/bin/sqitch $out/bin
    fixupPhase
    wrapProgram $out/bin/sqitch \
      --prefix PERL5LIB : \
      "$(for i in "$propagatedNativeBuildInputs" ; do
           for j in $(cat $i/nix-support/propagated-native-build-inputs) ; do
             echo -n "$j"/lib/perl5/site_perl:
           done
         done
         echo "$propagatedNativeBuildInputs"/lib/perl5/site_perl
        )"
  '';
}
