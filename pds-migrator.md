# PDS Migrator
A Project to make moving data between POD's easier

## PDS migration
More important than moving data in, is to know how to move data out. 
We want to do this from the frontend, not letting data reside on any intermediate server. 
Creating an app that makes moving data easy is our first step.

## Sustainable Storage
When your data is in a SOLID POD and you are using five different social networks,  three email clients, maybe hundreds of apps, moving your storage backend is a PITA when you need to change it at all those suppliers. We want to change this.
Redirecting: http status codes (B, C)
When PODs are migrated, it would be great if apps would still be able to reach the data. We would like to extend the specification. And the user should be in control. 
- 301 - Moved elsewhere permanently (key change)
- 307 - Temporary moved, (good change, maintenance?)
- 404 - Nothing here. (right to be forgotten? able to reuse?)
- 410 - No longer here. (prevent abuse by keeping it occupied)

## The storage side
The server needs to honour the user wishes and provide the correct status codes to apps, depending on data moved, permanently deleted, etc.

## The app side
Applications should follow the data, adjust records, especially after a 301. We will deliver demo code to demonstrate how this could work.
