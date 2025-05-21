import React from 'react';
import {
  Box,
  Button,
  Container,
  Heading,
  FormControl,
  FormLabel,
  Input,
  VStack,
  useToast,
  Switch,
  Text,
  Divider,
} from '@chakra-ui/react';
import DashboardLayout from '../../components/layout/DashboardLayout';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

interface Settings {
  id: number;
  email_notifications: boolean;
  report_auto_generation: boolean;
  default_language: string;
  timezone: string;
  created_at: string;
  updated_at: string;
}

export default function SettingsPage() {
  const toast = useToast();
  const queryClient = useQueryClient();

  const { data: settings } = useQuery<Settings>({
    queryKey: ['settings'],
    queryFn: async () => {
      const response = await fetch('http://localhost:3001/api/settings');
      if (!response.ok) {
        throw new Error('Failed to fetch settings');
      }
      return response.json();
    },
  });

  const updateSettings = useMutation({
    mutationFn: async (newSettings: Partial<Settings>) => {
      const response = await fetch('http://localhost:3001/api/settings', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newSettings),
      });
      if (!response.ok) {
        throw new Error('Failed to update settings');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['settings'] });
      toast({
        title: '설정이 저장되었습니다.',
        status: 'success',
        duration: 3000,
        isClosable: true,
      });
    },
  });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    updateSettings.mutate({
      email_notifications: formData.get('email_notifications') === 'true',
      report_auto_generation: formData.get('report_auto_generation') === 'true',
      default_language: formData.get('default_language') as string,
      timezone: formData.get('timezone') as string,
    });
  };

  return (
    <DashboardLayout>
      <Container maxW="container.xl" py={5}>
        <Heading mb={8}>설정</Heading>

        <Box as="form" onSubmit={handleSubmit}>
          <VStack spacing={8} align="stretch">
            <Box>
              <Heading size="md" mb={4}>알림 설정</Heading>
              <VStack spacing={4} align="stretch">
                <FormControl display="flex" alignItems="center">
                  <FormLabel htmlFor="email_notifications" mb="0">
                    이메일 알림
                  </FormLabel>
                  <Switch
                    id="email_notifications"
                    name="email_notifications"
                    defaultChecked={settings?.email_notifications}
                  />
                </FormControl>
                <FormControl display="flex" alignItems="center">
                  <FormLabel htmlFor="report_auto_generation" mb="0">
                    리포트 자동 생성
                  </FormLabel>
                  <Switch
                    id="report_auto_generation"
                    name="report_auto_generation"
                    defaultChecked={settings?.report_auto_generation}
                  />
                </FormControl>
              </VStack>
            </Box>

            <Divider />

            <Box>
              <Heading size="md" mb={4}>기본 설정</Heading>
              <VStack spacing={4} align="stretch">
                <FormControl>
                  <FormLabel>기본 언어</FormLabel>
                  <Input
                    name="default_language"
                    defaultValue={settings?.default_language}
                  />
                </FormControl>
                <FormControl>
                  <FormLabel>시간대</FormLabel>
                  <Input
                    name="timezone"
                    defaultValue={settings?.timezone}
                  />
                </FormControl>
              </VStack>
            </Box>

            <Button type="submit" colorScheme="brand" size="lg">
              설정 저장
            </Button>
          </VStack>
        </Box>
      </Container>
    </DashboardLayout>
  );
} 