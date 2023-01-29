# void-setup
Setup of Void Linux - currently work in progress

## Notes

To have the BE keyboard mapping with SDDM, edit the file /usr/share/sddm/scripts/Xsetup and add the line `setxkbmap be`


### Icons

I like the Bibata Modern Ice icons a lot. Download them from the release page of their [Github repository](https://github.com/ful1e5/Bibata_Cursor).

Decompress them and move the resulting directory (Bibata-*) to either ~/.icons/ for the current user or /usr/share/icons/ for all users

You can use LxAppearance to select the cursor theme. If it does not display correctly, have a look in ~/.icons/default/index.theme or /usr/share/icons/default/index.theme (if it does not exist, create it). It should have the following content:

```
[Icon Theme]
Inherits=Bibata-Modern-Ice
```

Save and exit your session then login again. The cursor should be ok in both SDDM and your tiling windows manager.
