import { writeFile } from "fs";
import * as pprof from "pprof"

export async function profile() {
  console.log("start to profile >>>");

  const profile = await pprof.time.profile({
    durationMillis: 60000,
  });
  const buf = await pprof.encode(profile);
  writeFile('wall.pb.gz', buf, (err: any) => { if (err) throw err; });

  console.log("<<< finished to profile");
}
