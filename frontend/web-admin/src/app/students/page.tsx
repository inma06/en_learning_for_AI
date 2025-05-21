'use client';

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
  Select,
  VStack,
  useToast,
} from '@chakra-ui/react';
import DashboardLayout from '../../components/layout/DashboardLayout';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

interface Student {
  id: number;
  academy_id: number;
  name: string;
  email: string;
  phone: string;
  grade: string;
  status: string;
  created_at: string;
}

interface Academy {
  id: number;
  name: string;
}

export default function StudentsPage() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const toast = useToast();
  const queryClient = useQueryClient();

  const { data: students, isLoading: studentsLoading } = useQuery<Student[]>({
    queryKey: ['students'],
    queryFn: async () => {
      const response = await fetch('http://localhost:3001/api/students');
      if (!response.ok) {
        throw new Error('Failed to fetch students');
      }
      return response.json();
    },
  });

  const { data: academies } = useQuery<Academy[]>({
    queryKey: ['academies'],
    queryFn: async () => {
      const response = await fetch('http://localhost:3001/api/academies');
      if (!response.ok) {
        throw new Error('Failed to fetch academies');
      }
      return response.json();
    },
  });

  const createStudent = useMutation({
    mutationFn: async (newStudent: Omit<Student, 'id' | 'created_at'>) => {
      const response = await fetch('http://localhost:3001/api/students', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newStudent),
      });
      if (!response.ok) {
        throw new Error('Failed to create student');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['students'] });
      toast({
        title: '학생이 등록되었습니다.',
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
    createStudent.mutate({
      academy_id: Number(formData.get('academy_id')),
      name: formData.get('name') as string,
      email: formData.get('email') as string,
      phone: formData.get('phone') as string,
      grade: formData.get('grade') as string,
      status: 'active',
    });
  };

  return (
    <DashboardLayout>
      <Container maxW="container.xl" py={5}>
        <Box display="flex" justifyContent="space-between" alignItems="center" mb={8}>
          <Heading>학생 관리</Heading>
          <Button colorScheme="brand" onClick={onOpen}>
            학생 등록
          </Button>
        </Box>

        <Table variant="simple">
          <Thead>
            <Tr>
              <Th>ID</Th>
              <Th>학원</Th>
              <Th>이름</Th>
              <Th>이메일</Th>
              <Th>전화번호</Th>
              <Th>학년</Th>
              <Th>상태</Th>
              <Th>등록일</Th>
            </Tr>
          </Thead>
          <Tbody>
            {students?.map((student) => (
              <Tr key={student.id}>
                <Td>{student.id}</Td>
                <Td>
                  {academies?.find((a) => a.id === student.academy_id)?.name}
                </Td>
                <Td>{student.name}</Td>
                <Td>{student.email}</Td>
                <Td>{student.phone}</Td>
                <Td>{student.grade}</Td>
                <Td>
                  <Badge colorScheme={student.status === 'active' ? 'green' : 'red'}>
                    {student.status === 'active' ? '활성' : '비활성'}
                  </Badge>
                </Td>
                <Td>{new Date(student.created_at).toLocaleDateString()}</Td>
              </Tr>
            ))}
          </Tbody>
        </Table>

        <Modal isOpen={isOpen} onClose={onClose}>
          <ModalOverlay />
          <ModalContent>
            <ModalHeader>학생 등록</ModalHeader>
            <ModalCloseButton />
            <ModalBody>
              <form onSubmit={handleSubmit}>
                <VStack gap={4}>
                  <FormControl isRequired>
                    <FormLabel>학원</FormLabel>
                    <Select name="academy_id">
                      {academies?.map((academy) => (
                        <option key={academy.id} value={academy.id}>
                          {academy.name}
                        </option>
                      ))}
                    </Select>
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>이름</FormLabel>
                    <Input name="name" />
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>이메일</FormLabel>
                    <Input name="email" type="email" />
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>전화번호</FormLabel>
                    <Input name="phone" />
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>학년</FormLabel>
                    <Input name="grade" />
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