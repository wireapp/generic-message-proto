1. Clone the project
2. Change to android/ directory in the project
3. Run sbt compile
4. Run sbt package
    * You should have the .jar file under android/target now.
5. sbt publishM2 publishes the .jar file to your local maven repo. 
    * Use this jar to verify that new version runs without problems.
6. sbt publish publishes to Bintray.
    * This command asks for bintray credentials.
