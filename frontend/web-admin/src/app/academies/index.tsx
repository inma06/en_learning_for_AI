import React from 'react';
import {
  Box,
  Button,
  Container,
  Heading,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Badge,
  useDisclosure,
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalBody,
  ModalCloseButton,
  FormControl,
  FormLabel,
  Input,
  VStack,
  useToast,
} from '@chakra-ui/react';
import DashboardLayout from '../../components/layout/DashboardLayout';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

interface Academy {
  id: number;
  name: string;
  address: string;
  phone: string;
  status: string;
  created_at: string;
}

export default function AcademiesPage() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const toast = useToast();
  const queryClient = useQueryClient();

  const { data: academies, isLoading } = useQuery<Academy[]>({
    queryKey: ['academies'],
    queryFn: async () => {
      const response = await fetch('http://localhost:3001/api/academies');
      if (!response.ok) {
        throw new Error('Failed to fetch academies');
      }
      return response.json();
    },
  });

  const createAcademy = useMutation({
    mutationFn: async (newAcademy: Omit<Academy, 'id' | 'created_at'>) => {
      const response = await fetch('http://localhost:3001/api/academies', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newAcademy),
      });
      if (!response.ok) {
        throw new Error('Failed to create academy');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['academies'] });
      toast({
        title: '학원이 생성되었습니다.',
        status: 'success',
        duration: 3000,
        isClosable: true,
      });
      onClose();
    },
  });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    createAcademy.mutate({
      name: formData.get('name') as string,
      address: formData.get('address') as string,
      phone: formData.get('phone') as string,
      status: 'active',
    });
  };

  return (
    <DashboardLayout>
      <Container maxW="container.xl" py={5}>
        <Box display="flex" justifyContent="space-between" alignItems="center" mb={8}>
          <Heading>학원 관리</Heading>
          <Button colorScheme="brand" onClick={onOpen}>
            학원 추가
          </Button>
        </Box>

        <Table variant="simple">
          <Thead>
            <Tr>
              <Th>ID</Th>
              <Th>학원명</Th>
              <Th>주소</Th>
              <Th>전화번호</Th>
              <Th>상태</Th>
              <Th>등록일</Th>
            </Tr>
          </Thead>
          <Tbody>
            {academies?.map((academy) => (
              <Tr key={academy.id}>
                <Td>{academy.id}</Td>
                <Td>{academy.name}</Td>
                <Td>{academy.address}</Td>
                <Td>{academy.phone}</Td>
                <Td>
                  <Badge colorScheme={academy.status === 'active' ? 'green' : 'red'}>
                    {academy.status === 'active' ? '활성' : '비활성'}
                  </Badge>
                </Td>
                <Td>{new Date(academy.created_at).toLocaleDateString()}</Td>
              </Tr>
            ))}
          </Tbody>
        </Table>

        <Modal isOpen={isOpen} onClose={onClose}>
          <ModalOverlay />
          <ModalContent>
            <ModalHeader>학원 추가</ModalHeader>
            <ModalCloseButton />
            <ModalBody>
              <form onSubmit={handleSubmit}>
                <VStack gap={4}>
                  <FormControl isRequired>
                    <FormLabel>학원명</FormLabel>
                    <Input name="name" />
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>주소</FormLabel>
                    <Input name="address" />
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>전화번호</FormLabel>
                    <Input name="phone" />
                  </FormControl>
                  <Button type="submit" colorScheme="brand" width="full" mb={4}>
                    등록
                  </Button>
                </VStack>
              </form>
            </ModalBody>
          </ModalContent>
        </Modal>
      </Container>
    </DashboardLayout>
  );
} 