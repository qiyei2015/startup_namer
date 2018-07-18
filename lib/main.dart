import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; // 新增了这一行

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new RandomWords(),
    );
  }
}

///创建State
class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    final WordPair wordPair = new WordPair.random();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Startup Name Generator"),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
          ],
        ),
        body: _buildSuggestions());
  }

  ///创建Widget
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          //奇数
          if (i.isOdd) {
            return new Divider();
          }
          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整）
          // 比如 i 为：1, 2, 3, 4, 5 时，结果为 0, 1, 1, 2, 2，
          // 这可以计算出 ListView 中减去分隔线后的实际单词对数量
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair wordPair) {
    //是否包含该item
    final bool alreadySaved = _saved.contains(wordPair);

    return new ListTile(
      title: new Text(wordPair.asPascalCase, style: _biggerFont),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }

  //入栈
  void _pushSaved() {
    //将MaterialPageRoute 推入栈中
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
                return new ListTile(
                  title: new Text(pair.asPascalCase, style: _biggerFont,),);
              },);

              final List<Widget> divided = ListTile.
              divideTiles(tiles: tiles,context: context)
                  .toList();
              
              return new Scaffold(
                appBar: new AppBar(
                  title: const Text('Saved Suggestions'),
                ),
                body: new ListView(children: divided,),
              );
            }
        )
    );
  }
}

///创建 Stateful widgets
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() {
    // TODO: implement createState
    return new RandomWordsState();
  }
}
