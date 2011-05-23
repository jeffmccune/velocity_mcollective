class stages {
  stage { 'setup':
    before => Stage['deploy'],
  }
  stage { 'deploy':
    before => Stage['main'],
  }
}

