1. Go to the right directory, 'cd HackTAMU25App' -> 'cd server'
2. In terminal, run command 'pip install -r requirements.txt'
3. Create a .env file in the same folder as main.py
4. Go to suno.com and create an account
5. Open DevTools (F12 or Function + F12) -> Network
6. Select the 'Fetch/XHR' filter and in the search bar type 'client?_'
7. Scroll down to 'Request Headers' and locate the 'Cookie:' header
8. Copy the string associated with this header and store it in the .env as 'SUNO_COOKIE=<cookie>' then save the file
9. In terminal, type 'python -m main'
 