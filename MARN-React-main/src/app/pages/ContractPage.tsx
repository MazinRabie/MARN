import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { Button } from '../components/ui/button'
import {
  Download,
  Upload,
  FileText,
  CheckCircle,
  Calendar,
  Home,
  User,
} from 'lucide-react'
import { useNavigate, useParams } from 'react-router'
import { useState } from 'react'
import { toast } from 'sonner'
import { Label } from '../components/ui/label'
import { Skeleton } from '../components/ui/skeleton'
import { useContract } from '@/hooks/useBookingRequests'
import { useTranslation } from 'react-i18next'
import { useAuth } from '@/hooks/useAuth'
import { rentalService } from '@/services/rentalService'

export interface ContractDetail {
  contractId: number | string;
  contractStatus: string;
  contractStatusDisplayName?: string;
  totalContractValue: number;
  propertyInfo?: {
    id?: string;
    name?: string;
  };
  ownerInfo?: {
    id?: string;
    fullName?: string;
  };
  renterInfo?: {
    id?: string;
    fullName?: string;
  };
  startDate: string;
  endDate?: string;
  isAnchoredToBlockChain?: boolean;
  anchoringStatus?: string;
  anchoringStatusDisplayName?: string;
  transactionId?: string;
  merkleRoot?: string;
}

export function ContractPage() {
  const { t, i18n } = useTranslation('contracts')
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()
  const [uploadedContract, setUploadedContract] = useState<File | null>(null)
  const { user } = useAuth()

  const { data: contractData, isLoading } = useContract(id)
  const contract = (contractData?.data as any as ContractDetail) ?? null

  const isCompleted = contract?.contractStatus === 'Active'

  const isOwner = contract?.ownerInfo?.id === user?.id
  const isTenant = contract?.renterInfo?.id === user?.id

  const [isDownloading, setIsDownloading] = useState(false)
  const handleDownload = async () => {
    if (!contract?.contractId) return;
    try {
      setIsDownloading(true);
      const res = await rentalService.downloadContract(contract.contractId.toString());
      const url = window.URL.createObjectURL(new Blob([res.data], { type: 'application/pdf' }));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `Contract_${contract.contractId}.pdf`);
      document.body.appendChild(link);
      link.click();
      window.URL.revokeObjectURL(url);
    } catch (e) {
      toast.error('Failed to download contract');
    } finally {
      setIsDownloading(false);
    }
  }

  const [isDownloadingProof, setIsDownloadingProof] = useState(false)
  const handleDownloadProof = async () => {
    if (!contract?.contractId) return;
    try {
      setIsDownloadingProof(true);
      const res = await rentalService.downloadOTS(contract.contractId.toString());
      const url = window.URL.createObjectURL(new Blob([res.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `Contract_${contract.contractId}_proof.ots`);
      document.body.appendChild(link);
      link.click();
      window.URL.revokeObjectURL(url);
    } catch (e) {
      toast.error(t('toasts.downloadProofError', { defaultValue: 'Failed to download proof' }));
    } finally {
      setIsDownloadingProof(false);
    }
  }

  const [isVerifying, setIsVerifying] = useState(false)
  const handleVerifyContract = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file || !contract?.contractId) return;

    try {
      setIsVerifying(true);
      const formData = new FormData();
      formData.append('file', file);
      formData.append('contractId', contract.contractId.toString());
      await rentalService.verifyContract(formData);
      toast.success(t('toasts.verifySuccess', { defaultValue: 'Contract verified successfully' }));
    } catch (error) {
      toast.error(t('toasts.verifyError', { defaultValue: 'Failed to verify contract or mismatch' }));
    } finally {
      setIsVerifying(false);
      if (e.target) {
         e.target.value = '';
      }
    }
  }

  const [isSigning, setIsSigning] = useState(false)
  const handleSign = async () => {
    if (!contract?.contractId) return;
    try {
      setIsSigning(true);
      await rentalService.signContract(contract.contractId.toString());
      toast.success(t('toasts.signed', { defaultValue: 'Contract submitted, awaiting review' }));
      navigate('/');
    } catch (e) {
      toast.error('Failed to sign contract');
    } finally {
      setIsSigning(false);
    }
  }

  if (isLoading) {
    return (
      <div className="min-h-screen py-20">
        <div className="max-w-[900px] mx-auto px-8 space-y-6">
          <Skeleton className="h-10 w-32 rounded" />
          <Skeleton className="h-24 w-full rounded-3xl" />
          <Skeleton className="h-64 w-full rounded-3xl" />
          <Skeleton className="h-48 w-full rounded-3xl" />
        </div>
      </div>
    )
  }

  if (!contract) {
    return (
      <div className="min-h-screen py-20 flex items-center justify-center text-[#4a5565]">
        {t('notFound')}
      </div>
    )
  }

  return (
    <div className="min-h-screen py-20">
      <div className="max-w-[900px] mx-auto px-8">
        <Button
          variant="ghost"
          onClick={() => navigate(-1)}
          className="mb-6 rounded-xl hover:bg-[#E5EBF0]/50"
        >
          <span className={i18n.language === 'ar' ? 'ml-2' : 'mr-2'}>
            {i18n.language === 'ar' ? '→' : '←'}
          </span>
          {t('back')}
        </Button>

        <div className="mb-8">
          <h1 className="text-4xl font-bold text-[#1a1a1a] mb-2">
            {t('title')}
          </h1>
          <p className="text-lg text-[#6B7280]">
            {t('subtitle')}
          </p>
        </div>

        {/* Contract Status */}
        <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 mb-6">
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div
                  className={`w-12 h-12 rounded-full flex items-center justify-center ${isCompleted ? 'bg-green-100' : 'bg-yellow-100'
                    }`}
                >
                  {isCompleted ? (
                    <CheckCircle className="w-6 h-6 text-green-600" />
                  ) : (
                    <FileText className="w-6 h-6 text-yellow-600" />
                  )}
                </div>
                <div>
                  <h3 className="font-semibold text-[#1a1a1a]">
                    {t('contractStatus')}
                  </h3>
                  <p className="text-sm text-[#6B7280]">
                    {contract.contractStatus === 'Pending' && t('statusText.awaitingSignatures')}
                    {contract.contractStatus === 'Active' && t('statusText.fullyExecuted')}
                    {contract.contractStatus === 'Expired' && t('statusText.expired')}
                    {contract.contractStatus === 'Terminated' && t('statusText.terminated')}
                  </p>
                </div>
              </div>
              <div
                className={`px-4 py-2 rounded-full text-sm font-medium ${isCompleted
                    ? 'bg-green-100 text-green-700'
                    : 'bg-yellow-100 text-yellow-700'
                  }`}
              >
                {contract.contractStatusDisplayName || contract.contractStatus}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Contract Details */}
        <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 mb-6">
          <CardHeader>
            <CardTitle className="text-2xl text-[#1a1a1a]">
              {t('contractDetails')}
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <p className="text-sm text-[#6B7280] mb-1">{t('contractId')}</p>
                <p className="font-semibold text-[#1a1a1a]">{contract.contractId}</p>
              </div>
              <div>
                <p className="text-sm text-[#6B7280] mb-1">{t('monthlyRent')}</p>
                <p className="font-semibold text-[#1a1a1a]">
                  EGP {(contract.totalContractValue || 0).toLocaleString()}
                </p>
              </div>
            </div>

            {/* Property Info */}
            <div className="p-4 bg-white rounded-2xl">
              <div className="flex items-center gap-2 mb-3">
                <Home className="w-5 h-5 text-[#3A6EA5]" />
                <h4 className="font-semibold text-[#1a1a1a]">{t('property')}</h4>
              </div>
              <p className="font-medium text-[#1a1a1a] mb-2">
                {contract.propertyInfo?.name}
              </p>
              <p className="text-lg font-bold text-[#3A6EA5]">
                EGP {(contract.totalContractValue || 0).toLocaleString()}/month
              </p>
            </div>

            {/* Parties */}
            <div className="grid md:grid-cols-2 gap-4">
              <div className="p-4 bg-white rounded-2xl">
                <div className="flex items-center gap-2 mb-3">
                  <User className="w-5 h-5 text-[#3A6EA5]" />
                  <h4 className="font-semibold text-[#1a1a1a]">{t('tenant')}</h4>
                </div>
                <p className="font-medium text-[#1a1a1a]">
                  {contract.renterInfo?.fullName}
                </p>
              </div>
              {contract.ownerInfo?.fullName && (
                <div className="p-4 bg-white rounded-2xl">
                  <div className="flex items-center gap-2 mb-3">
                    <User className="w-5 h-5 text-[#3A6EA5]" />
                    <h4 className="font-semibold text-[#1a1a1a]">{t('owner')}</h4>
                  </div>
                  <p className="font-medium text-[#1a1a1a]">
                    {contract.ownerInfo.fullName}
                  </p>
                </div>
              )}
            </div>

            {/* Rental Period */}
            <div className="p-4 bg-white rounded-2xl">
              <div className="flex items-center gap-2 mb-3">
                <Calendar className="w-5 h-5 text-[#3A6EA5]" />
                <h4 className="font-semibold text-[#1a1a1a]">{t('rentalPeriod')}</h4>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-[#6B7280] mb-1">{t('startDate')}</p>
                  <p className="font-medium text-[#1a1a1a]">
                    {new Date(contract.startDate).toLocaleDateString('en-US', {
                      month: 'long',
                      day: 'numeric',
                      year: 'numeric',
                    })}
                  </p>
                </div>
                <div>
                  <p className="text-sm text-[#6B7280] mb-1">{t('endDate')}</p>
                  <p className="font-medium text-[#1a1a1a]">
                    {contract.endDate ? new Date(contract.endDate).toLocaleDateString('en-US', {
                      month: 'long',
                      day: 'numeric',
                      year: 'numeric',
                    }) : '-'}
                  </p>
                </div>
              </div>
            </div>

            {/* Blockchain Verification */}
            {contract.isAnchoredToBlockChain && (
              <div className="p-4 bg-white rounded-2xl border border-green-100">
                <div className="flex items-center gap-2 mb-3">
                  <CheckCircle className="w-5 h-5 text-green-600" />
                  <h4 className="font-semibold text-[#1a1a1a]">{t('blockchainVerification', { defaultValue: 'Blockchain Verification' })}</h4>
                </div>
                <div className="space-y-3">
                  <div>
                    <p className="text-sm text-[#6B7280] mb-1">{t('anchoringStatus', { defaultValue: 'Anchoring Status' })}</p>
                    <p className="font-medium text-green-700 flex items-center gap-2">
                      <span className="w-2 h-2 rounded-full bg-green-500"></span>
                      {contract.anchoringStatusDisplayName || contract.anchoringStatus}
                    </p>
                  </div>
                  {contract.transactionId && (
                    <div>
                      <p className="text-sm text-[#6B7280] mb-1">{t('transactionId', { defaultValue: 'Transaction ID' })}</p>
                      <p className="text-xs font-mono bg-[#f5f7fa] p-2 rounded-lg text-[#4a5565] break-all border border-[#E5EBF0]">
                        {contract.transactionId}
                      </p>
                    </div>
                  )}
                  {contract.merkleRoot && (
                    <div>
                      <p className="text-sm text-[#6B7280] mb-1">{t('merkleRoot', { defaultValue: 'Merkle Root' })}</p>
                      <p className="text-xs font-mono bg-[#f5f7fa] p-2 rounded-lg text-[#4a5565] break-all border border-[#E5EBF0]">
                        {contract.merkleRoot}
                      </p>
                    </div>
                  )}
                </div>
              </div>
            )}

            <div className="p-4 bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] rounded-2xl text-white">
              <p className="text-sm mb-1 opacity-90">{t('monthlyRent')}</p>
              <p className="text-3xl font-bold">
                EGP {(contract.totalContractValue || 0).toLocaleString()}
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Conditional Actions */}
        {!isCompleted && contract?.contractStatus === 'Pending' && isOwner && (
          <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 mb-6">
            <CardContent className="pt-6">
              <div className="flex flex-col items-center justify-center p-6 text-center">
                <FileText className="w-12 h-12 text-[#3A6EA5] mb-4" />
                <h3 className="text-xl font-semibold text-[#1a1a1a] mb-2">
                  {t('awaitingTenantSignature', { defaultValue: 'Contract sent to tenant' })}
                </h3>
                <p className="text-[#6B7280]">
                  {t('awaitingTenantSignatureDesc', { defaultValue: 'Awaiting signature from the tenant.' })}
                </p>
              </div>
            </CardContent>
          </Card>
        )}

        {!isCompleted && contract?.contractStatus === 'Pending' && isTenant && (
          <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 mb-6">
            <CardHeader>
              <CardTitle className="text-2xl text-[#1a1a1a]">
                {t('signContract', { defaultValue: 'Sign Contract' })}
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="p-6 bg-white rounded-2xl text-center">
                <p className="text-[#6B7280] mb-6">
                  {t('signContractDesc', { defaultValue: 'By clicking below, you digitally sign the contract and it will be recorded on the blockchain.' })}
                </p>
                <Button
                  onClick={handleSign}
                  disabled={isSigning}
                  className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2C5580] hover:to-[#3A6EA5] text-white rounded-xl px-8"
                >
                  <CheckCircle className="w-5 h-5 mr-2" />
                  {isSigning ? t('signing', { defaultValue: 'Signing...' }) : t('signContractButton', { defaultValue: 'Sign Contract' })}
                </Button>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Download Contract (Visible when Active) */}
        {isCompleted && (
          <Card className="bg-[#E5EBF0] border-none rounded-3xl shadow-lg shadow-[#3A6EA5]/10 mb-6">
            <CardHeader>
              <CardTitle className="text-2xl text-[#1a1a1a]">
                {t('download')}
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="p-6 bg-white rounded-2xl">
                <div className="flex items-start gap-4">
                  <div className="w-16 h-16 rounded-2xl bg-[#E5EBF0] flex items-center justify-center flex-shrink-0">
                    <FileText className="w-8 h-8 text-[#3A6EA5]" />
                  </div>
                  <div className="flex-1">
                    <h4 className="font-semibold text-[#1a1a1a] mb-1">
                      {t('rentalAgreementPdf')}
                    </h4>
                    <p className="text-sm text-[#6B7280] mb-4">
                      {t('rentalAgreementDesc')}
                    </p>
                    <div className="flex flex-wrap gap-3">
                      <Button
                        onClick={handleDownload}
                        disabled={isDownloading}
                        className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2C5580] hover:to-[#3A6EA5] text-white rounded-xl"
                      >
                        <Download className="w-4 h-4 mr-2" />
                        {isDownloading ? t('downloading', { defaultValue: 'Downloading...' }) : t('download')}
                      </Button>

                      <Button
                        onClick={handleDownloadProof}
                        disabled={isDownloadingProof}
                        variant="outline"
                        className="rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5]/10"
                      >
                        <Download className="w-4 h-4 mr-2" />
                        {isDownloadingProof ? t('downloading', { defaultValue: 'Downloading...' }) : t('downloadProof', { defaultValue: 'Download Proof' })}
                      </Button>

                      <div>
                        <input
                          type="file"
                          id="verify-contract"
                          className="hidden"
                          onChange={handleVerifyContract}
                          accept=".pdf"
                        />
                        <Button
                          asChild
                          variant="outline"
                          className={`rounded-xl border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5]/10 ${isVerifying ? 'opacity-50 pointer-events-none' : ''}`}
                        >
                          <label htmlFor="verify-contract" className="cursor-pointer">
                            <Upload className="w-4 h-4 mr-2" />
                            {isVerifying ? t('verifying', { defaultValue: 'Verifying...' }) : t('verifyContract', { defaultValue: 'Verify Contract' })}
                          </label>
                        </Button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Important Notes */}
        {!isCompleted && (
          <Card className="bg-yellow-50 border-2 border-yellow-200 rounded-3xl">
            <CardHeader>
              <CardTitle className="text-xl text-yellow-900">
                {t('importantNotes.title')}
              </CardTitle>
            </CardHeader>
            <CardContent className="text-sm text-yellow-800 space-y-2">
              <p>• {t('importantNotes.readCarefully')}</p>
              <p>• {t('importantNotes.bothParties')}</p>
              <p>• {t('importantNotes.keepCopy')}</p>
              <p>• {t('importantNotes.contactSupport')}</p>
              <p>• {t('importantNotes.effectiveDate')}</p>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  )
}
