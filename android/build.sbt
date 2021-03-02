import protocbridge.Target

name := "generic-message-proto"
organization := "com.wire"

version := "1.28.1"

crossPaths := false
scalaVersion := "2.11.12"

licenses += ("GPL-3.0", url("https://opensource.org/licenses/GPL-3.0"))

libraryDependencies ++= Seq(
  "com.google.protobuf" % "protobuf-java" % "3.14.0",
  "com.google.protobuf" % "protobuf-javalite" % "3.14.0"
)

Compile / PB.protoSources := Seq(baseDirectory.value.getParentFile / "proto")
Compile / PB.targets := Seq(
  Target(PB.gens.java, (Compile / sourceManaged).value, Seq("lite"))
)
// Prevents the plugin from adding libraryDependencies to your project
PB.additionalDependencies := Nil
PB.deleteTargetDirectory := false

homepage := Some(url("https://github.com/wireapp/generic-message-proto"))

// based on http://caryrobbins.com/dev/sbt-publishing/
publishMavenStyle := true
pomIncludeRepository := { _ => false }
publishTo := {
  val nexus = "https://oss.sonatype.org/"
  if (isSnapshot.value)
    Some("snapshots" at nexus + "content/repositories/snapshots")
  else
    Some("releases"  at nexus + "service/local/staging/deploy/maven2")
}

scmInfo := Some(
  ScmInfo(
    url("https://github.com/wireapp/generic-message-proto"),
    "scm:git:git@github.com:wireapp/generic-message-proto.git"
  )
)

developers := List(
  Developer("makingthematrix", "Maciej Gorywoda", "maciej.gorywoda@wire.com", url("https://github.com/makingthematrix"))
)

resolvers ++= Seq(
  Resolver.sonatypeRepo("releases"),
  Resolver.sonatypeRepo("public"),
  Resolver.mavenLocal
)

publishConfiguration      := publishConfiguration.value.withOverwrite(true)
publishLocalConfiguration := publishLocalConfiguration.value.withOverwrite(true)
publishM2Configuration    := publishM2Configuration.value.withOverwrite(true)

usePgpKeyHex("4D4389633F8B177CCB25457391F612D8C344D422")