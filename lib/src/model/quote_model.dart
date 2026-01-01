class QuoteModel {
  final int id;
  final String quote;
  final String author;

  QuoteModel({required this.id, required this.quote, required this.author});

  factory QuoteModel.formJson(Map<String, dynamic> data) {
    return QuoteModel(
      id: data['id'],
      quote: data['quote'],
      author: data['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }

  @override
  toString() => "QuoteModel(id: $id, quote: 4quote, author: $author)";
}
