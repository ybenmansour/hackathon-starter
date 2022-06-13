const sonarqubeScanner =  require('sonarqube-scanner');
sonarqubeScanner(
    {
        serverUrl:  'http://sonarqube:9000',
        options : {
            'sonar.projectName': 'hackathon-starter',   
            'sonar.sources':  '.',
            'sonar.tests':  'src',
            'sonar.inclusions'  :  '**', 
        }
    }, () => {});
