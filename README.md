# MassReporting
Dreamforce Demos - Mass Report Generation Using REST

This is the demonstation code that I gave for my Dreamforce 2015 session on Mass Customer Report Generation using REST.

It contains a JSON demo, an HTTP callout/REST demo, and the mass report generations classes and pages.

Instructions:

The demsotration code was executed as follows:

// Demo 1 - JSON demo
// JSONdemo.rundemo();

// Demo 2 - REST callout
// NOTE: you must configure remote site settings
// HTTPcalloutbasic.callREST();

/* Demo 3 - Mass report generation
// NOTE: you must configure remote site settings (if not already done).
// NOTE: you must create a connected app for Oauth 2.0 authentication.
// NOTE: you must add the proper credentials to the Secret class.
Init.removeAccounts();          // removes our test accounts
Init.createAccounts(100);       // creates 100 fake test accounts
Bulkgenerate.startProcess();    // initiates mass report generation process
*/

Nem Stefanovic
nem@kooltra.com
