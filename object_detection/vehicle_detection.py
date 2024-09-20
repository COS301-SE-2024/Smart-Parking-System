import cv2
import subprocess
import time
import numpy as np  # The hero import!
import math


def capture_frame_ffmpeg(youtube_url):
    # Use yt-dlp to extract the live stream URL
    cmd = ['yt-dlp', '-f', 'best', '-g', youtube_url]
    stream_url = subprocess.check_output(cmd, shell=True).strip().decode('utf-8')

    # Open the live stream using OpenCV VideoCapture
    cap = cv2.VideoCapture(stream_url)
    ret, frame = cap.read()
    cap.release()
    
    if not ret:
        print("Failed to capture frame from stream")
        return None

    return frame

def detect_cars_in_youtube_stream(youtube_url, output_path):
    # Load YOLOv3 network
    net = cv2.dnn.readNet("yolov3.weights", "yolov3.cfg")
    
    # Load class names
    with open("coco.names", "r") as f:
        classes = [line.strip() for line in f.readlines()]

    # Set up output layers
    layer_names = net.getLayerNames()
    output_layers = [layer_names[i - 1] for i in net.getUnconnectedOutLayers()]

    total_car_count = 0
    frames_to_capture = 4

    for i in range(frames_to_capture):
        # Capture frame from live stream
        frame = capture_frame_ffmpeg(youtube_url)
        
        if frame is None:
            print(f"Skipping frame capture {i + 1} due to error")
            continue
        
        print(f"Captured frame {i + 1} shape: {frame.shape}")

        # Define the region of interest (ROI) - the red box
        roi_x1, roi_y1 = 200, 500  # Top-left corner (x, y)
        roi_x2, roi_y2 = 1700, 800  # Bottom-right corner (x, y)

        # Crop the frame to the ROI (red box)
        roi_frame = frame[roi_y1:roi_y2, roi_x1:roi_x2]

        cars_count = process_frame(roi_frame, net, output_layers, classes)
        total_car_count += cars_count

        # Add the red box back to the original frame for visualization
        cv2.rectangle(frame, (roi_x1, roi_y1), (roi_x2, roi_y2), (0, 0, 255), 2)  # Red box
        
        # Display results on the original frame
        cv2.putText(frame, f"Cars: {cars_count}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        cv2.imwrite(f"{output_path}_frame_{i + 1}.jpg", frame)

        print(f"Cars detected in frame {i + 1}: {cars_count}")
        time.sleep(1)  # Optional delay between frames

    # Compute the average car count from 4 frames
    average_car_count = total_car_count / frames_to_capture
    rounded_car_count = math.ceil(average_car_count)  # Use math.ceil() to round up

    print(f"Average number of cars detected over {frames_to_capture} frames: {average_car_count}")
    print(f"Rounded up car count: {rounded_car_count}")

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


# Example usage
youtube_live_url = "https://youtu.be/CH8GegCF9FI"
detect_cars_in_youtube_stream(youtube_live_url, "output_frame.jpg")
