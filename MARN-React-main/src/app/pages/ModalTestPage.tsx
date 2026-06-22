import { useState } from 'react'
import { RentalUsersModal } from '../components/RentalUsersModal'
import { Button } from '../components/ui/button'
import { Users } from 'lucide-react'

// Sample data for testing
const SAMPLE_USERS = [
  {
    id: '1',
    name: 'Ahmed Hassan',
    photo:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
    rentalEndDate: 'April 15, 2026',
    contractId: 'CNT-2024-001',
  },
  {
    id: '2',
    name: 'Fatima Mohamed',
    photo:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop',
    rentalEndDate: 'May 22, 2026',
    contractId: 'CNT-2024-002',
  },
  {
    id: '3',
    name: 'Omar Ibrahim',
    photo:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop',
    rentalEndDate: 'March 30, 2026',
    contractId: 'CNT-2024-003',
  },
  {
    id: '4',
    name: 'Layla Ali',
    photo:
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop',
    rentalEndDate: 'June 10, 2026',
    contractId: 'CNT-2024-004',
  },
  {
    id: '5',
    name: 'Khalid Mahmoud',
    photo:
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop',
    rentalEndDate: 'July 5, 2026',
    contractId: 'CNT-2024-005',
  },
]

export function ModalTestPage() {
  const [isModalOpen, setIsModalOpen] = useState(false)

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#F2F4F6] to-[#9CBBDC] flex items-center justify-center px-4 py-20">
      <div className="max-w-4xl w-full">
        <div className="bg-white rounded-3xl p-8 md:p-12 shadow-2xl shadow-[#3A6EA5]/20 text-center">
          <div className="w-20 h-20 rounded-full bg-gradient-to-br from-[#3A6EA5] to-[#9CBBDC] flex items-center justify-center mx-auto mb-6">
            <Users className="w-10 h-10 text-white" />
          </div>

          <h1 className="text-4xl font-bold text-[#1a1a1a] mb-4">
            Rental Users Modal Test
          </h1>

          <p className="text-lg text-[#4a5565] mb-8">
            Click the button below to view the rental users modal with sample
            data
          </p>

          <Button
            onClick={() => setIsModalOpen(true)}
            className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl px-8 py-6 text-lg"
          >
            <Users className="w-5 h-5 mr-2" />
            Open Rental Users Modal
          </Button>

          <div className="mt-12 grid md:grid-cols-2 gap-6 text-left">
            <div className="bg-[#F2F4F6] rounded-2xl p-6">
              <h3 className="font-semibold text-[#1a1a1a] mb-3">
                Modal Features:
              </h3>
              <ul className="space-y-2 text-sm text-[#4a5565]">
                <li>✓ User profile photos</li>
                <li>✓ Tenant names</li>
                <li>✓ Rental period end dates</li>
                <li>✓ Days remaining indicator</li>
                <li>✓ Download contract button</li>
                <li>✓ Active status indicator</li>
              </ul>
            </div>

            <div className="bg-[#F2F4F6] rounded-2xl p-6">
              <h3 className="font-semibold text-[#1a1a1a] mb-3">
                Sample Users:
              </h3>
              <ul className="space-y-2 text-sm text-[#4a5565]">
                <li>• {SAMPLE_USERS.length} tenants loaded</li>
                <li>• Various rental end dates</li>
                <li>• Expiring soon warnings</li>
                <li>• Unique contract IDs</li>
                <li>• Egyptian tenant names</li>
              </ul>
            </div>
          </div>
        </div>

        {/* The Modal Component */}
        <RentalUsersModal
          open={isModalOpen}
          onOpenChange={setIsModalOpen}
          users={SAMPLE_USERS}
          propertyName="Luxury Apartment in Zamalek"
        />
      </div>
    </div>
  )
}
