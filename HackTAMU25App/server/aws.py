import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

def upload_file_to_s3(bucket_name, file_path, object_name=None, region="us-east-1"):
    s3 = boto3.client('s3', region_name=region)

    if object_name is None:
        object_name = file_path.split('/')[-1]

    try:
        # Upload file with public-read ACL
        s3.upload_file(file_path, bucket_name, object_name, ExtraArgs={'ACL': 'public-read'})
        
        # Construct and return the file URL
        url = f"https://{bucket_name}.s3.{region}.amazonaws.com/{object_name}"
        return url
    except Exception as e:
        print(f"Error uploading file: {e}")
        return None
    
if __name__ == "__main__":
    url = upload_file_to_s3("brainbeats1", "tmp.txt")
    print('url', url)
