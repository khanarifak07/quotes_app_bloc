import 'package:flutter/material.dart';
import 'package:quotes_app_bloc/src/utils/utils.dart';

import '../../../model/quote_model.dart';

class QuotesCard extends StatelessWidget {
  const QuotesCard({
    super.key,
    required this.quote,
    required this.onSave,
    required this.onShare,
  });

  final QuoteModel quote;
  final VoidCallback onShare;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        tileColor: Colors.blue.withValues(alpha: 0.3),
        title: Text(quote.quote),
        subtitle: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text("~\t${quote.author}"),
            ),
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onSave,
                  icon: Icon(
                    isSaved(quote) ? Icons.favorite : Icons.favorite_outline,
                  ),
                ),
                IconButton(
                  onPressed: onShare,
                  icon: Icon(Icons.share_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

bool isSaved(QuoteModel quote) {
  final savedQuotes = Utils.getSavedQuotes();
  final isSaved = savedQuotes.any((e) => e.id == quote.id);
  return isSaved;
}
