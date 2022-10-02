## 3 Musketeers: high-level summary

* 3 Musketeers is a pattern for developing software in a repeatable and consistent manner
* It leverages `Make` as an orchestration tool to test, build, run, and deploy applications using `Docker` and `Docker Compose`
* The `Make` and `Docker/Compose` commands for each application are maintained as part of the application’s source code and are invoked in the same way whether run locally or on a CI/CD server.

    ![image info](img/3-musk-image.svg)

The benefits of using 3 Musketeers are:

#### Consistency
Run the same commands no matter what environment you're using:
* OS: Linux, MacOS, Windows
* CI/CD tools that supports Docker like GitHub Actions, Travis CI, CircleCI, and GitLab CI
#### Confidence
* Test your code and pipelines locally before your CI/CD tool runs it
* Feel confident that if it works locally, it will work in your CI/CD server
#### Control
* Take control of languages, versions, and tools you need, and version source control your pipelines with your preferred VCS like GitHub and GitLab.