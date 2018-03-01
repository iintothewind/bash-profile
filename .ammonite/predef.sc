import coursier.ivy.IvyRepository
import coursier.ivy.Pattern
import coursier.maven.MavenRepository
import coursier.core.Authentication

repl.prompt() = "> "

interp.repositories.update(interp.repositories().filterNot(_.toString.contains("repo1")))

interp.repositories() ++= Seq(
  MavenRepository("http://maven.aliyun.com/nexus/content/groups/public"),
  MavenRepository("https://dl.bintray.com/typesafe/maven-releases"),
  IvyRepository.fromPattern("http://dl.bintray.com/typesafe/ivy-releases" +: Pattern.default),
  IvyRepository.fromPattern("http://dl.bintray.com/sbt/sbt-plugin-releases" +: Pattern.default),
  MavenRepository("https://jcenter.bintray.com"),
  MavenRepository("https://oss.sonatype.org/content/repositories"),
  MavenRepository("https://dl.bintray.com/typesafe/maven-releases"),
  MavenRepository("https://repo1.maven.org/maven2")
)












