import 'package:flutter_demo/core/annotations.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/src/builder/builder.dart' show Builder, BuilderOptions;
import 'package:build/src/builder/build_step.dart' show BuildStep;
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart' hide LibraryBuilder;
import 'package:dart_style/dart_style.dart';

const _autowriteChecker = TypeChecker.fromRuntime(Autowrite);
const _requestNetworkChecker = TypeChecker.fromRuntime(RequestNetwork);

const _networkCheckerReference = Reference("NetworkChecker");

List<ClassElement> injectInfo = [];

class ProviderGenerator extends GeneratorForAnnotation<Inject> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    Iterable<FieldElement>? fields;
    if (element is ClassElement) {
      fields = element.fields.where((f) => _autowriteChecker.hasAnnotationOfExact(f));
    }
    if (fields == null) return;
    injectInfo.add(element as ClassElement);

    var clazzs = createProxyClass(fields);

    Method method = createMethodUseToInject(fields, element, clazzs);

    var output = DartFormatter().format('${method.accept(DartEmitter())}');
    var clazzsOutput = DartFormatter().format('${clazzs.first.accept(DartEmitter())}');
    return """
        part of 'package:flutter_demo/core/injector.injector.dart';
        $output
        $clazzsOutput
    """;
  }

  List<Class> createProxyClass(Iterable<FieldElement> fields) {
    List<Class> result = [];
    for (var element in fields) {
      ClassElement? classElement;
      if (element.type.element is ClassElement) {
        classElement = element.type.element as ClassElement;
      }
      if (classElement == null) continue;
      List<Reference> mixins = [];
      List<Method> methods = [];
      for (var element in classElement.methods) {
        if (_requestNetworkChecker.hasAnnotationOfExact(element)) {
          if (!mixins.contains(_networkCheckerReference)) mixins.add(_networkCheckerReference);
          methods.add(
            Method.returnsVoid(
              (b) => b
                ..name = element.name
                ..annotations.add(const Reference("override"))
                ..modifier = MethodModifier.async
                ..requiredParameters.addAll(
                  element.parameters.map(
                    (e) => Parameter(
                      (pb) {
                        pb.type = refer(e.type.getDisplayString(withNullability: true));
                        pb.name = e.name;
                      },
                    ),
                  ),
                )
                ..body = const Code("""
                    try {
                      await checkNetwork();
                      super.loadData();
                    } catch (_) {}
                """),
            ),
          );
        }
      }

      Class clazz = Class(
        (b) => b
          ..name = "${element.type.getDisplayString(withNullability: false)}Proxy"
          ..extend = Reference(classElement!.name)
          ..mixins.addAll(mixins)
          ..constructors.add(
            Constructor(
              (constructorBuild) {
                constructorBuild.requiredParameters.addAll(
                  classElement!.constructors.first.parameters.map(
                    (element) => Parameter(
                      (pb) {
                        pb.type = refer(element.type.getDisplayString(withNullability: true));
                        pb.name = element.name;
                      },
                    ),
                  ),
                );
                String parametersString = classElement.constructors.first.parameters.map((parameter) => parameter.name).join(",");
                constructorBuild.initializers.add(Code('super($parametersString)'));
              },
            ),
          )
          ..methods.addAll(methods),
      );
      result.add(clazz);
    }
    return result;
  }

  Method createMethodUseToInject(Iterable<FieldElement> fields, ClassElement element, List<Class> clazzs) {
    String code = fields
        .map((element) =>
            'state.${element.name} = ${clazzs.firstWhere((clazz) => clazz.extend!.symbol == element.type.getDisplayString(withNullability: false)).name}(state.widget.inputParams);')
        .join();
    final method = Method.returnsVoid(
      (b) => b
        ..name = 'inject${element.name}'
        ..requiredParameters.add(
          Parameter(
            (pb) {
              pb.type = refer(element.name);
              pb.name = 'state';
            },
          ),
        )
        ..body = Code(code),
    );
    return method;
  }
}

class InjectProvider extends GeneratorForAnnotation<Injector> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    Class clazz = Class(
      (b) => b
        ..name = "InjectorProxy"
        ..methods.add(
          Method.returnsVoid(
            (b) => b
              ..name = 'inject'
              ..requiredParameters.add(
                Parameter(
                  (pb) {
                    pb.type = refer('BaseState');
                    pb.name = 'state';
                  },
                ),
              )
              ..body = Code(
                """
                ${injectInfo.map((e) => "if(state is ${e.name}){inject${e.name}(state);return;}").join()}

                """,
              ),
          ),
        ),
    );
    var output = DartFormatter().format('${clazz.accept(DartEmitter())}');
    return """
        import 'package:flutter_demo/core/base.dart';
        import 'package:flutter_demo/intercept/network_checker.dart';
        ${injectInfo.map((e) => "import '${e.librarySource.uri}';").join()}
        ${injectInfo.map((e) => "part '${e.librarySource.uri.toString().replaceAll('.dart', ".provider.dart")}';").join()}
        $output
    """;
  }
}

Builder providerBuilder(BuilderOptions options) => LibraryBuilder(
      ProviderGenerator(),
      generatedExtension: '.provider.dart',
    );

Builder injectorProvider(BuilderOptions options) => LibraryBuilder(
      InjectProvider(),
      generatedExtension: '.injector.dart',
    );
