# import firebase
from firebase import Storage
from firebase import Firebase

config = {
  "apiKey": "AIzaSyAzunLzmO1Tdf58XcCYmm2Q72EbyEToTJY",
  "authDomain": "firephotos-40d70.appspot.com",
  "databaseURL": "https://firephotos-40d70-default-rtdb.firebaseio.com",
  "storageBucket": "firephotos-40d70.appspot.com"
}

firebase = Firebase(config)

storageURL = "gs://firephotos-40d70.appspot.com/"
folderURL = "images/"

# storage = Storage.storage(url:"gs://firephotos-40d70.appspot.com")
# storageRef = Storage.storage(url:"gs://firephotos-40d70.appspot.com").reference().child("images")
# imageURL = URL(
#     string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1920px-Apple_logo_black.svg.png")
storage = firebase.storage()
storage_images = storage.child('images')

storageSize = storage_images.list_files()
print(storageSize)
storageItems: [FirebaseStorage.StorageReference] = []
