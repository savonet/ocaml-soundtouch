module C = Configurator.V1

exception Found of C.Pkg_config.package_conf

let pkg_config_names = ["soundtouch"; "libSoundTouch"; "soundtouch-1.4"]

let () =
  C.main ~name:"soundtouch-pkg-config" (fun c ->
      let default : C.Pkg_config.package_conf =
        { libs = ["-lSoundTouch"]; cflags = [] }
      in
      let conf =
        match C.Pkg_config.get c with
          | None -> default
          | Some pc -> (
              try
                List.iter
                  (fun package ->
                    match C.Pkg_config.query pc ~package with
                      | Some deps -> raise (Found deps)
                      | None -> ())
                  pkg_config_names;
                default
              with Found deps -> deps)
      in

      C.Flags.write_sexp "c_flags.sexp" ("-fPIC" :: conf.cflags);
      C.Flags.write_sexp "c_library_flags.sexp" ("-lstdc++" :: conf.libs);

      let has_top_level_header =
        C.c_test c
          ~c_flags:("-x" :: "c++" :: conf.cflags)
          ~link_flags:conf.libs
          {|
        #include <SoundTouch.h>

        int main() {
          return 0;
        }
      |}
      in

      C.C_define.gen_header_file c ~fname:"config.h"
        [("HAS_TOP_LEVEL_HEADER", Switch has_top_level_header)])
