String corrigirURL(String url) {
  return url.replaceAll('\\/', '/');
}

void main() {
  String urlComErro = "https:\/\/cdn.api-futebol.com.br\/escudos\/638d3492a6e0b.svg";
  String urlCorrigida = corrigirURL(urlComErro);
  print(urlCorrigida);
}
