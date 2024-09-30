import cv2
import time
import numpy as np # The hero import!
import math
import os
import yt_dlp
from flask import Flask, request, jsonify

app = Flask(__name__)

def capture_frame_ffmpeg(youtube_url):
    ydl_opts = {
        'quiet': True,
        'no_warnings': True,
        'format': 'best'
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        try:
            info_dict = ydl.extract_info(youtube_url, download=False)
            stream_url = info_dict['url']
        except yt_dlp.utils.DownloadError as e:
            print(f"Error extracting stream URL: {e}")
            return None

    cap = cv2.VideoCapture(stream_url)
    ret, frame = cap.read()
    cap.release()
    
    if not ret:
        print("Failed to capture frame from stream")
        return None

    return frame

def detect_cars_in_youtube_stream(youtube_url, output_path):
    net = cv2.dnn.readNet("yolov3.weights", "yolov3.cfg")
    
    with open("coco.names", "r") as f:
        classes = [line.strip() for line in f.readlines()]

    layer_names = net.getLayerNames()
    output_layers = [layer_names[i - 1] for i in net.getUnconnectedOutLayers()]

    total_car_count = 0
    frames_to_capture = 3

    for i in range(frames_to_capture):
        frame = capture_frame_ffmpeg(youtube_url)
        
        if frame is None:
            print(f"Skipping frame capture {i + 1} due to error")
            continue
        
        roi_x1, roi_y1 = 180, 520
        roi_x2, roi_y2 = 1700, 1000
        roi_frame = frame[roi_y1:roi_y2, roi_x1:roi_x2]

        cars_count = process_frame(roi_frame, net, output_layers, classes)
        total_car_count += cars_count

        cv2.rectangle(frame, (roi_x1, roi_y1), (roi_x2, roi_y2), (0, 0, 255), 2)
        cv2.putText(frame, f"Cars Detected: {cars_count}", (10, 70), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        cv2.imwrite(f"{output_path}_frame_{i + 1}.jpg", frame)

        time.sleep(1)

    average_car_count = total_car_count / frames_to_capture
    rounded_car_count = math.ceil(average_car_count)

    return rounded_car_count

def process_frame(frame, net, output_layers, classes):
    height, width, _ = frame.shape
    blob = cv2.dnn.blobFromImage(frame, 1/255, (608, 608), (0, 0, 0), True, crop=False)

    net.setInput(blob)
    outs = net.forward(output_layers)
    
    class_ids = []
    confidences = []
    boxes = []

    confidence_threshold = 0.1
    nms_threshold = 0.3
    
    for out in outs:
        for detection in out:
            scores = detection[5:]
            class_id = np.argmax(scores)
            confidence = scores[class_id]
            class_name = classes[class_id]
            
            if class_name == 'car' and confidence > confidence_threshold:
                center_x = int(detection[0] * width)
                center_y = int(detection[1] * height)
                w = int(detection[2] * width)
                h = int(detection[3] * height)
                x = int(center_x - w / 2)
                y = int(center_y - h / 2)
                boxes.append([x, y, w, h])
                confidences.append(float(confidence))
                class_ids.append(class_id)
    
    indexes = cv2.dnn.NMSBoxes(boxes, confidences, confidence_threshold, nms_threshold)
    cars_count = len(indexes)
    
    for i in range(len(boxes)):
        if i in indexes:
            x, y, w, h = boxes[i]
            label = f"Car: {confidences[i]:.2f}"
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
            cv2.putText(frame, label, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    return cars_count


@app.route('/detect-cars', methods=['POST'])
def detect_cars():
    try:
        youtube_url = request.json.get('youtube_url')
        if not youtube_url:
            return jsonify({"error": "youtube_url parameter is required"}), 400

        car_count = detect_cars_in_youtube_stream(youtube_url, "output_frame")
        return jsonify({"car_count": car_count}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))