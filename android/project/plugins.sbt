addSbtPlugin("com.github.gseitz" % "sbt-release" % "1.0.12")
addSbtPlugin("org.xerial.sbt" % "sbt-sonatype" % "3.9.5")
addSbtPlugin("com.jsuereth" % "sbt-pgp" % "2.1.1")

addSbtPlugin("com.thesamet" % "sbt-protoc" % "1.0.0")

libraryDependencies ++= Seq(
  "com.thesamet.scalapb" %% "compilerplugin" % "0.10.10"
)