{deployAndroidPackage, lib, package, os, autoPatchelfHook, makeWrapper, pkgs, pkgsi686Linux}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") [ pkgs.glibc pkgs.ncurses5 pkgsi686Linux.glibc pkgsi686Linux.ncurses5 ];
  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      autoPatchelf .
    ''}

    # Wrap all scripts that require JAVA_HOME
    for i in bin
    do
        find $i -maxdepth 1 -type f -executable | while read program
        do
            if grep -q "JAVA_HOME" $program
            then
                wrapProgram $PWD/$program --prefix PATH : ${pkgs.jdk8}/bin
            fi
        done
    done
 
    # Patch all script shebangs
    patchShebangs .
  '';

  meta.license = lib.licenses.unfree;
}
