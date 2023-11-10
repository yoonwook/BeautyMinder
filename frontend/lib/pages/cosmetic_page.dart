import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cosmetic/cosmetic_bloc.dart';  // BLoC import
import '../bloc/cosmetic/cosmetic_event.dart';  // 이벤트 import
import '../bloc/cosmetic/cosmetic_state.dart';  // 상태 import

class CosmeticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('화장품 관리')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                print('Text Field Value: $value');
                BlocProvider.of<CosmeticBloc>(context).add(SearchCosmetics(value));
              },
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search cosmetics",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CosmeticBloc, CosmeticState>(
              builder: (context, state) {
                print('State Updated: $state');
                if (state is CosmeticInitial) {
                  return CircularProgressIndicator();
                } else if (state is CosmeticLoaded) {
                  return ListView.builder(
                    itemCount: state.cosmetics.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.cosmetics[index].name),
                        subtitle: Text("만료 날짜: ${state.cosmetics[index].expirationDate}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            BlocProvider.of<CosmeticBloc>(context)
                                .add(DeleteCosmetic(state.cosmetics[index].id!.toString()));
                          },
                        ),
                      );
                    },
                  );
                } else if (state is CosmeticError) {
                  return Center(child: Text(state.message));
                }
                return Offstage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
