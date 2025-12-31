import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: true
  ),
);

typedef LogMessage = void Function(dynamic message, {String? tag});

void pinfo(dynamic message, {String? tag}) {
  logger.i(_format(message, tag));
}

void perror(dynamic message, {String? tag}) {
  logger.e(_format(message, tag));
}

void pwarnings(dynamic message, {String? tag}) {
  logger.w(_format(message, tag));
}

void ptrace(dynamic message, {String? tag}) {
  logger.t(_format(message, tag));
}

void pdebug(dynamic message, {String? tag}) {
  logger.d(_format(message, tag));
}

String _format(dynamic message, String? tag) {
  if (tag != null && tag.isNotEmpty) {
    return '[$tag] $message';
  }
  return message.toString();
}
