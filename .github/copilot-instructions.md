# Instrucciones de Copilot para so-sps

## Resumen del Repositorio

Describe aqui el objetivo funcional del servicio Java y sus integraciones.

## Stack Tecnologico

- Stack principal: java
- Runtime: Java
- Build: Maven o Gradle
- Runner ARC: arc-ocp-bro2socp4

## Entorno ARC

- El agente ejecuta en runners ARC efimeros sobre OpenShift.
- El workflow de setup es `.github/workflows/copilot-setup-steps.yml`.
- Si el proyecto depende de repositorios Maven privados, documentarlo antes de
  pedir compilaciones al agente.

## Comandos de Validacion

```bash
mvn -version
java -version
```

## Restricciones

- No hardcodear secretos.
- No cambiar `runs-on` sin coordinacion con infraestructura.
- No cambiar el nombre del job `copilot-setup-steps`.
- Revisar con cuidado estas rutas sensibles:

```text
src/main/resources/
pom.xml
```
