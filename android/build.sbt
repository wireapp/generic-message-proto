import com.github.os72.protocjar.Protoc.runProtoc

name := "generic-message-proto"
organization := "com.wire"

version := "1.23.0"

crossPaths := false
scalaVersion := "2.11.8"

licenses += ("GPL-3.0", url("https://opensource.org/licenses/GPL-3.0"))
bintrayOrganization := Some("wire-android")
bintrayRepository := "releases"

lazy val generateSources = taskKey[Seq[File]]("generate-proto")

generateSources := {
  val outDir = (sourceManaged in Compile).value / "compiled-proto"
  val protoDir = baseDirectory.value.getParentFile / "proto"

  outDir.mkdirs()

  val exitCode = runProtoc(("-v300" +: s"--javanano_out=store_unknown_fields=true:${outDir.getAbsolutePath}" +: s"--proto_path=${protoDir.getAbsolutePath}" +: (protoDir * "*.proto").get.map(_.getAbsolutePath)).toArray)

  if (exitCode != 0) sys.error(s"protoc failed with exit code $exitCode")

  (outDir ** "*.java").get
}

sourceGenerators in Compile += generateSources.taskValue

javacOptions ++= Seq("-source", "1.7", "-target", "1.7", "-encoding", "UTF-8")
scalacOptions ++= Seq("-feature", "-target:jvm-1.7", "-Xfuture", "-deprecation", "-Yinline-warnings", "-encoding", "UTF-8")

ivyLoggingLevel := UpdateLogging.Quiet // otherwise update logging will overwrite protoc compile errors after a "clean"
libraryDependencies += "com.google.protobuf.nano" % "protobuf-javanano" % "3.0.0-alpha-5"

publishArtifact in (Compile, packageDoc) := false
publishArtifact in (Compile, packageSrc) := false
