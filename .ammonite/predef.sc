repl.prompt() = "> "

interp.repositories.update(interp.repositories().filterNot(_.toString.contains("repo1")))

interp.repositories() ++= Seq(
  coursierapi.MavenRepository.of("http://maven.aliyun.com/nexus/content/groups/public"),
  coursierapi.MavenRepository.of("https://dl.bintray.com/typesafe/maven-releases"),
  coursierapi.IvyRepository.of("http://dl.bintray.com/typesafe/ivy-releases/[defaultPattern]"),
  coursierapi.IvyRepository.of("http://dl.bintray.com/sbt/sbt-plugin-releases/[defaultPattern]"),
  coursierapi.MavenRepository.of("https://jcenter.bintray.com"),
  coursierapi.MavenRepository.of("https://oss.sonatype.org/content/repositories"),
  coursierapi.MavenRepository.of("https://dl.bintray.com/typesafe/maven-releases"),
  coursierapi.MavenRepository.of("https://repo1.maven.org/maven2")
)
