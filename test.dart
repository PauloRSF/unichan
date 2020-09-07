import 'lib/services/API.dart';

main () async {
	//var posts = await API().getThreadsOps();
	var posts = await API().getFullThread(31187829);
	for (var p in posts) {
		print(p.repliesNos);
	}
}