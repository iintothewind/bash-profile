cancelable in Global := true

ensimeRepositoryUrls in ThisBuild += "https://maven.aliyun.com/nexus/content/groups/public"
ensimeIgnoreScalaMismatch in ThisBuild := true
ensimeJavaFlags in ThisBuild := Seq("-Xss512M", "-Xmx4G", "-XX:MaxMetaspaceSize=768M")

assemblyMergeStrategy in assembly := {
  case PathList("META-INF", xs@_*) => MergeStrategy.discard
  case _ => MergeStrategy.first
}

resolvers ++= Seq(
  Resolver.mavenLocal,
  MavenRepository("aliyun", "https://maven.aliyun.com/nexus/content/groups/public")
)
