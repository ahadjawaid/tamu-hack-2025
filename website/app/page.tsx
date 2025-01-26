"use client"
import Image from 'next/image';
import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useToast } from "@/hooks/use-toast"
import { CheckCircle, XCircle, Users } from 'lucide-react';

export default function Home() {
  const [email, setEmail] = useState('');
  const { toast } = useToast()
  const [isSubmitting, setIsSubmitting] = useState(false);
  const googleFormAction = 'https://docs.google.com/forms/d/e/1FAIpQLSfLZIK2VP_JimUlGZiwnsiyP7GbfdAElBvdC3fKk1mib6pCsA/formResponse';
  const emailFieldName = 'entry.142330486';
  const earlySupports = 4;

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      await fetch(googleFormAction, {
        method: 'POST',
        mode: 'no-cors',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ [emailFieldName]: email }),
      });

      toast({
        title: "Success!",
        description: "You have been added to the waitlist!",
        variant: "default",
        className: "bg-white text-black",
        action: <CheckCircle className="w-5 h-5 text-green-500" />,
      })

      setEmail('');
    } catch (error) {
      toast({
        title: "Error",
        description: "An error occurred. Please try again.",
        variant: "destructive",
        className: "bg-white border-red-500 text-black",
        action: <XCircle className="w-5 h-5 text-red-500" />,
      })

      console.error('Error submitting form:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className='relative min-h-screen'>
      <Image 
        src="/hero-bg.svg"
        alt="Background"
        width={1920}
        height={1080}
        className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 opacity-80"
        priority
      />
      
      <div className='relative min-h-screen max-w-7xl mx-auto px-4 flex flex-col justify-between'>
        <div className='flex flex-col sm:gap-y-18 md:gap-y-22'>
          <nav className='py-8 sm:py-12 md:py-16'>
            <Image src="/logo.svg" alt="Logo" width={150} height={50} />
          </nav>

          <main className='flex flex-col gap-y-24 sm:flex-row justify-between items-center'>
            <div className="flex flex-col gap-y-8 max-w-2xl">
              <div className='w-full'>
                <h1 className="mb-4 sm:mb-6 text-2xl sm:text-3xl md:text-4xl font-bold leading-tight">
                  Where music meets knoweldge.
                </h1>
                <p className="text-md sm:text-lg md:text-xl text-zinc-400">
                  Make learning engaging with custom generated songs pertaining to different educational subjects
                </p>
              </div>

              <div className='block md:hidden mx-auto'>
                <Image src="/hero.png" alt="Hero" width={300} height={300} priority />
              </div>

              <form className='flex flex-col gap-y-6' onSubmit={handleSubmit}>
                <div className="space-y-3">
                  <div className="flex flex-col sm:flex-row gap-x-6 gap-y-3">
                    <div className="flex-1">
                      <label className="sr-only">Email</label>
                      <Input
                        className="bg-white text-black h-12"
                        type="email"
                        placeholder="name@email.com"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        required
                      />
                    </div>

                    <Button
                      type="submit"
                      disabled={isSubmitting}
                      className='bg-yellow-400 hover:bg-yellow-500 h-12 text-black px-8 font-medium text-sm sm:text-md md:text-lg'
                    >
                      {isSubmitting ? 'Submitting...' : 'Join Waitlist'}
                    </Button>
                  </div>
                  <div className="flex items-center justify-center sm:justify-start gap-x-2 text-zinc-500 text-sm sm:text-base">
                    <Users className="w-4 h-4" />
                    <span>{earlySupports.toLocaleString()} early supporters (updates daily)</span>
                  </div>
                </div>
              </form>
            </div>

            <div className='hidden md:block'>
              <Image
                src="/hero.png"
                alt="Hero"
                width={425}
                height={425}
                className="drop-shadow-2xl pt-24"
                priority
              />
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}