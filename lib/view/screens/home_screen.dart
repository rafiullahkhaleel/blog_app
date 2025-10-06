import 'package:blog_app/provider/fetch_provider.dart';
import 'package:blog_app/provider/post_provider.dart';
import 'package:blog_app/utils/cached_network_image/image_save.dart';
import 'package:blog_app/view/screens/auth/register_screen.dart';
import 'package:blog_app/view/screens/post_screen.dart';
import 'package:blog_app/view/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => FetchProvider()..fetch(),

      child: Builder(
        builder: (context) {
          return Consumer<FetchProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                onVerticalDragEnd: (_) {
                  provider.fetch();
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      provider.isSelectionMode
                          ? "${provider.selectedItems.length} Selected"
                          : 'Blog',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    actions: [
                      if (provider.selectedItems.length == 1)
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            final docsId = provider.selectedItems.keys.first;
                            final data = provider.snapshot.firstWhere(
                              (element) => element.docsId == docsId,
                            );
                            postProvider.docsId = docsId;
                            postProvider.forEdit(data);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PostScreen(),
                              ),
                            );
                          },
                        ),
                      if (provider.isSelectionMode)
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            provider.delete(context);
                          },
                        )
                      else ...[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PostScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.add, color: Colors.white, size: 28),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text("Logout"),
                                    ],
                                  ),
                                  content: Text(
                                    "Are you sure you want to logout?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // dialog close
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => RegisterScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],

                      SizedBox(width: 5),
                    ],
                    backgroundColor: AppColors.mainColor,
                    centerTitle: true,
                  ),
                  body: Consumer<FetchProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (provider.error != null) {
                        return Center(
                          child: Text(
                            'ERROR OCCURRED: ${provider.error}',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              child: CustomField(
                                labelText: 'Search',
                                controller: provider.filterController,
                                onChanged: (value) {
                                  provider.filter(value);
                                },
                              ),
                            ),
                            provider.snapshot.isEmpty
                                ? Expanded(
                                  child: Center(
                                    child: Text(
                                      'No data available',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                                : Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: provider.snapshot.length,
                                    itemBuilder: (context, index) {
                                      final data = provider.snapshot[index];
                                      final createAt = data.createAt;
                                      final isSelected = provider.selectedItems
                                          .containsKey(data.docsId);
                                      return GestureDetector(
                                        onLongPress: () {
                                          provider.addIdsForDelete(
                                            data.docsId,
                                            data.imageUrl,
                                          );
                                        },
                                        onTap:
                                            provider.isSelectionMode
                                                ? () {
                                                  provider.addIdsForDelete(
                                                    data.docsId,
                                                    data.imageUrl,
                                                  );
                                                }
                                                : null,
                                        child: Card(
                                          color:
                                              isSelected
                                                  ? Colors.green.shade200
                                                  : Colors.white,
                                          elevation: 5,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: SmartCacheImage(
                                                    height: height * .3,
                                                    width: double.infinity,
                                                    url: data.imageUrl,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  data.title,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      spacing: 3,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_outlined,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'hh:mm a',
                                                          ).format(createAt),
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .grey
                                                                    .shade600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      spacing: 3,
                                                      children: [
                                                        Icon(
                                                          Icons.date_range,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'dd MMM, yyyy',
                                                          ).format(createAt),
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .grey
                                                                    .shade600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  data.description,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
