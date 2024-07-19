// TODO 앱 도장 깨기 두 번째 미션 정답입니다.
// import 할 파일 경로는 각자 다를 것이므로 생략했습니다.
// 구현 방법은 다양하므로 참고 정도만 하기 바랍니다.

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> todoList = [];
  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Already exists"),
              content: const Text("This task is alerady exists"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          });
      return;
    }
    setState(() {
      todoList.insert(0, todoText);
    });
    writeLocalData();
    Navigator.pop(context);
  }

  void writeLocalData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //todoList = prefs.getStringList('todoList')!;
    setState(() {
      todoList = (prefs.getStringList('todoList') ?? []).toList();
    });
  }

  void showAddTodoBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              child: AddTask(addTodo: addTodo),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Codingchef"),
              accountEmail: const Text("codingchefdev@gmail.com"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset("images/codingchef2.png"),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://www.youtube.com/@codingchef"));
              },
              leading: const Icon(Icons.youtube_searched_for_rounded),
              title: const Text("About me"),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://www.gmail.com"));
              },
              leading: const Icon(Icons.mail_outline_rounded),
              title: const Text("About me"),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://www."));
              },
              leading: const Icon(Icons.shape_line_outlined),
              title: const Text("Share"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("TODO App"),
        centerTitle: true,
      ),
      body: (todoList.isEmpty)
          ? const Center(
              child: Text(
                "No items on the List",
                style: TextStyle(fontSize: 20, color: Colors.purple),
              ),
            )
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      todoList.removeAt(index);
                    });
                    writeLocalData();
                  },
                  child: ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  todoList.removeAt(index);
                                });
                                writeLocalData();
                                Navigator.pop(context);
                              },
                              child: const Text("Task done!"),
                            ),
                          );
                        },
                      );
                    },
                    title: Text(todoList[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTodoBottomSheet;
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
