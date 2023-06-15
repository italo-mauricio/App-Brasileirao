import 'package:flutter/material.dart';
import 'DescriptionsMatches.dart';

class MatchesWidget extends StatefulWidget {
  final List jsonObjects;
  
  MatchesWidget({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  _MatchesWidgetState createState() => _MatchesWidgetState();
}

class _MatchesWidgetState extends State<MatchesWidget> {
  int selectedMatchIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.jsonObjects.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            setState(() {
              selectedMatchIndex = index;
            });
          },
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.network(
                      widget.jsonObjects[index]["time_mandante"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Text(widget.jsonObjects[index]["sigla_mandante"]),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.jsonObjects[index]["placar"],
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(widget.jsonObjects[index]["data"] +
                        " " +
                        widget.jsonObjects[index]["hora"]),
                  ],
                ),
                Column(
                  children: [
                    Image.network(
                      widget.jsonObjects[index]["time_visitante"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Text(widget.jsonObjects[index]["sigla_visitante"]),
                  ],
                ),
              ],
            ),
          ),
          subtitle: selectedMatchIndex == index
              ? Description(id: widget.jsonObjects[index]["partida"], value: null,)
              : null,
        );
      },
    );
  }
}