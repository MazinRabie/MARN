import { useState } from 'react'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/app/components/ui/dialog'
import { Button } from '@/app/components/ui/button'
import { loadStripe } from '@stripe/stripe-js'
import { Elements, PaymentElement, useStripe, useElements } from '@stripe/react-stripe-js'
import { toast } from 'sonner'
import { useTranslation } from 'react-i18next'

const STRIPE_PUBLIC_KEY = 'pk_test_51TShoRFRF2lAYwLKqrYByDaXS5kq65rKMiqcIrnt1yN8B0abcTwLMVlw9Iw0JbJOBwJOIixKX7QzpZiIZCXtajTz004qzGhjXQ'
const stripePromise = loadStripe(STRIPE_PUBLIC_KEY)

function CheckoutForm({ onSuccess, onCancel }: { onSuccess: () => void, onCancel: () => void }) {
  const stripe = useStripe()
  const elements = useElements()
  const [isProcessing, setIsProcessing] = useState(false)
  const { t } = useTranslation('common')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!stripe || !elements) return

    setIsProcessing(true)

    const { error, paymentIntent } = await stripe.confirmPayment({
      elements,
      confirmParams: {
        return_url: window.location.href,
      },
      redirect: 'if_required',
    })

    setIsProcessing(false)

    if (error) {
      toast.error(error.message || 'Payment failed')
    } else if (paymentIntent && paymentIntent.status === 'succeeded') {
      toast.success('Payment successful!')
      onSuccess()
    } else {
      // In case it's processing or requires further action handled by redirect
      onSuccess()
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <PaymentElement />
      <div className="flex justify-end gap-3 pt-4 border-t border-[#3A6EA5]/10">
        <Button variant="outline" type="button" onClick={onCancel} className="rounded-xl" disabled={isProcessing}>
          Cancel
        </Button>
        <Button 
          type="submit" 
          disabled={!stripe || isProcessing}
          className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl"
        >
          {isProcessing ? 'Processing...' : 'Pay Now'}
        </Button>
      </div>
    </form>
  )
}

interface PaymentModalProps {
  clientSecret: string | null
  onClose: () => void
  onSuccess: () => void
}

export function PaymentModal({ clientSecret, onClose, onSuccess }: PaymentModalProps) {
  if (!clientSecret) return null

  return (
    <Dialog open={!!clientSecret} onOpenChange={(open: boolean) => !open && onClose()}>
      <DialogContent aria-describedby={undefined} className="bg-white rounded-3xl p-6 sm:max-w-md w-[95vw] mx-auto border-none shadow-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="text-2xl font-bold text-[#1a1a1a]">Secure Payment</DialogTitle>
          <DialogDescription className="text-sm text-[#4a5565]">
            Complete your rent payment securely via Stripe.
          </DialogDescription>
        </DialogHeader>
        <div className="mt-4">
          <Elements stripe={stripePromise} options={{ clientSecret }}>
            <CheckoutForm onSuccess={onSuccess} onCancel={onClose} />
          </Elements>
        </div>
      </DialogContent>
    </Dialog>
  )
}
