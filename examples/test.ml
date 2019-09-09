module S = Soundtouch

let () =
  let chans = 2 in
  let samplerate = 44100 in
  let s = S.make chans samplerate in
  Printf.printf "Sountouch version %s\n\n%!" (S.get_version_string s);
  let buflen = 10000 in
  let buf = Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout (chans*buflen) in
  S.put_samples_ba s buf
