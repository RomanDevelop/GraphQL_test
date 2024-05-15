import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfig.client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Flutter GraphQL Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter GraphQL Demo'),
      ),
      body: Center(
        child: Query(
          options: QueryOptions(
            document: gql(r'''
              query GetUsers {
                users {
                  id
                  name
                  email
                }
              }
            '''),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return CircularProgressIndicator();
            }

            List users = result.data!['users'];

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
