import coursier.MavenRepository
import coursier.core.Authentication
repl.prompt() = "> "

interp.repositories.update(interp.repositories().filterNot(_.toString.contains("repo1")))

interp.repositories() ++= Seq(
  MavenRepository("http://maven.aliyun.com/nexus/content/groups/public"),
  MavenRepository("https://repo1.maven.org/maven2")
)












