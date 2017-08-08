from setuptools import find_packages, setup
setup(name="#{packageName}",
      version="#{packageVersion}",
      description="My CICD starter app",
      author="Russell Endicott",
      author_email='russell.endicott@ge.com',
      platforms=["any"],  # or more specific, e.g. "win32", "cygwin", "osx"
      license="BSD",
      url="https://github.build.ge.com/212601587/CICD101-Russell.git",
      packages=find_packages(),
      )
