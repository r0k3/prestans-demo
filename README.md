Demo Application for prestans REST micro-framework
==================================================

Written to run under Google's AppEngine, this application showcases the features of prestans, a WSGI compliant REST micro-framework. 

Running the demo app
--------------------

Grab your self a copy of Google's AppEngine SDK v1.7+, you will require Python 2.7.x to run this SDK

Clone the demo application repository:

    git clone https://github.com/prestans/prestans-demo 

this should clone everything you need to run the demo application. Start the AppEngine SDK server in the app directory:

    cd prestans-demo/app
    dev_appserver.py .

Use a browser to navigate to http://localhost:8080/

