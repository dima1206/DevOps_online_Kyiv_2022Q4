from flask import Flask, render_template
import random

app = Flask(__name__)

# list of images
images = [
    "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg",
    "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg",
    "https://images.pexels.com/photos/104827/cat-pet-animal-domestic-104827.jpeg",
    "https://images.pexels.com/photos/320014/pexels-photo-320014.jpeg",
    "https://images.pexels.com/photos/20787/pexels-photo.jpg",
]

@app.route('/')
def index():
    url = random.choice(images)
    return render_template('index.html', url=url)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
