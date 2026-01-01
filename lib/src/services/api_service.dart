class ApiService {
  ApiService._(); //prevents instance creations

  static const baseURL = 'https://dummyjson.com';

  static const getAllQuotes = '$baseURL/quotes?limit=0';

  static String getAllQuotesPagination(int skip) =>
      '$baseURL/quotes?limit=10&skip=$skip';
}
