### Upgrading from 0.1.0 to >= 0.2.0

When upgrading from 0.1.0 (pre-Mongoid 3.0) to 0.2.0 (Mongoid 3.x), you'll need to upgrade any existing snapshots created by mongoid_collection_snapshot 0.1.0 in your database before they're usable. You can do this by renaming the 'workspace_slug' attribute to 'slug' in MongoDB after upgrading. For example, to upgrade the snapshot class "MySnapshot", you'd enter the following at the mongo shell.

```
db.my_snapshot.rename({ 'workspace_slug' : { '$exists' : true } }, {'$rename' : {'workspace_slug' : 'slug' } })
```

