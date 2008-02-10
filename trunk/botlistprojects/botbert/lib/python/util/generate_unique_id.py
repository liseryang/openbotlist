##
## generate_unique_id.py
##
## Copyright Berlin Brown
##
## Simple script to generate UUID
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
## LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
## A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
## CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
## PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
## LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
## NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
## SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##

import time, random, md5

def botlist_uuid(*args):
  """
    Generates a universally unique ID.
    Any arguments only create more randomness.
  """
  t = long( time.time() * 1000 )
  r = long( random.random()*100000000000000000L )
  try:
    a = socket.gethostbyname( socket.gethostname() )
  except:
    # if we can't get a network address, just imagine one
    a = random.random()*100000000000000000L

  # Extra protection, additional unique md5 call
  t2 = long( time.time() * 1000 )
  r2 = long( random.random()*100000000000000000L )
	
  data = str(t)+' '+str(r)+' '+str(a)+' '+str(args)
  data = md5.md5(data).hexdigest()

  # Additional
  data2 = str(t2)+' '+str(r2)+' '+str(a)+' '+str(args)
  data2 = md5.md5(data2).hexdigest()

  # Final result
  uuid_data = "%s%s" % (data, data2)  
  return uuid_data[0:42]

if __name__ == '__main__':
	print "Simple uuid:"
	v = uuid("objid:%s" % "1312")
	print "[%s] : %s" % (v, len(v))
	print "Done"

# End of Script
